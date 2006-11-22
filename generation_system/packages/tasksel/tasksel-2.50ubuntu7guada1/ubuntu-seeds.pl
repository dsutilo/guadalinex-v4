#!/usr/bin/perl -w
#
# ubuntu-seeds outdir suite flavour ...
#
# Process Task-* fields from the seeds for each of the specified flavours,
# and turn them into task description files. The Task field in the resulting
# task description file will be the seed name, except for per-derivative
# seeds (see below). Each field has "Task-" stripped from the front and is
# then used verbatim, with the following exceptions:
#
#   Task-Per-Derivative:
#     Seeds with this field set to a true value will have the seed name and
#     a dash prepended to the task name (so "desktop" in the "ubuntu" seeds
#     becomes "ubuntu-desktop"). Seeds without this field will only be
#     processed in the first flavour specified on the command line.
#
#   Task-Extended-Description:
#     The content of this field will be used as the continuation of the
#     Description field.

use strict;
use File::Path;
use File::Temp qw(tempdir);

my $seed_base='http://bazaar.launchpad.net/~ubuntu-core-dev/ubuntu-seeds';
my $outdir=shift or die "no output directory specified\n";
my $suite=shift or die "no suite specified\n";
my @flavours=@ARGV;
@flavours >= 1 or die "no flavours specified\n";

if (-d $outdir) {
	rmtree $outdir or die "can't remove old $outdir: $!\n";
}
mkpath $outdir or die "can't create $outdir: $!\n";

my $tempdir=tempdir('tasksel-XXXXXX', TMPDIR => 1, CLEANUP => 1);

for my $flavour (@flavours) {
	my $checkout="$tempdir/checkout-$flavour";
	my @command=('bzr', 'get', "$seed_base/$flavour.$suite", $checkout);
	my $ret=system(@command);
	if ($ret != 0) {
		my $commandstr=join(' ', @command);
		die "'$commandstr' failed with exit status $ret\n";
	}

	my @seeds;
	local *STRUCTURE;
	open STRUCTURE, "$checkout/STRUCTURE"
		or die "can't open $checkout/STRUCTURE: $!\n";
	while (<STRUCTURE>) {
		chomp;
		next if /^#/;
		if (/^(.*?):/) {
			push @seeds, $1;
		}
	}
	close STRUCTURE;

	for my $seed (@seeds) {
		my %fields;
		my @fieldorder;
		local *SEED;
		open SEED, "$checkout/$seed"
			or die "can't open $checkout/$seed: $!\n";
		while (<SEED>) {
			chomp;
			next unless /^Task-(.*?):\s*(.*)/i;
			$fields{lc $1}=$2;
			push @fieldorder, $1;
		}
		close SEED;
		next unless keys %fields;

		my $task=$seed;
		if ($fields{'per-derivative'}) {
			$task="$flavour-$seed";
		} elsif ($flavour ne $flavours[0]) {
			next;
		}

		open TASK, '>', "$outdir/$task"
			or die "can't open $outdir/$task for writing: $!\n";
		print TASK "Task: $task\n"
			or die "can't write to $outdir/$task: $!\n";
		for my $field (@fieldorder) {
			my $lcfield=lc $field;
			next if $lcfield eq 'per-derivative' or
				$lcfield eq 'extended-description';
			if ($lcfield eq 'key') {
				# must be multi-line
				my @values=split /,*\s+/, $fields{$lcfield};
				print TASK "$field:\n" .
					   join('', map(" $_\n", @values))
					or die "can't write to " .
					       "$outdir/$task: $!\n";
			} else {
				print TASK "$field: $fields{$lcfield}\n"
					or die "can't write to " .
					       "$outdir/$task: $!\n";
			}
			if ($lcfield eq 'description' and
			    exists $fields{'extended-description'}) {
				print TASK " $fields{'extended-description'}\n"
					or die "can't write to " .
					       "$outdir/$task: $!\n";
			}
		}
		unless (exists $fields{packages}) {
			print TASK "Packages: task-fields\n"
				or die "can't write to $outdir/$task: $!\n";
		}
		close TASK or die "can't close $outdir/$task: $!\n";
	}
}
