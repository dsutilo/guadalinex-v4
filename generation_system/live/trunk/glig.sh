#!/bin/bash

log_file="/var/log/glig-$(date +%Y%d%M%H%M).log"

# Functions
function error() {

	echo "Error: $*"
	exit

}

function must_be_root() {

	id=$(id -u)
	if [ "$id" != 0 ]; then
		error "You are not a root and you need to be root to run this script"
	fi

}

function log_it() {

	code="$1"
	shift
	msg="$*"
	case $code in
		0)
			echo "${msg} ($(date +'%b %e %H:%M:%S')): OK" | tee -a $log_file
			;;
		*)
			echo "${msg} ($(date +'%b %e %H:%M:%S')): Fail" | tee -a $log_file #FIXME: Hacer echo por stderr?
			;;
	esac
}

function get_config() {

	paths="/etc/glig $HOME/glig ."
	
	any_path=false
	for path in $paths;
		do
		if [ -f "${path}/conf" ]; then
			. ${path}/conf
			any_path=true
		fi
	done
	
	if [ $any_path = false ]; then
		error "There is not any conf file in $paths"
		exit
	fi
	
	escaped_sources=$(echo $sources | sed 's|/|\\/|g')
	log_it "$?" "get_config"

}

function apt_get() {

	export LC_ALL=C LANGUAGE=C LANG=C DEBIAN_FRONTEND=noninteractive 
	chroot ${sources} apt-get -f -y --force-yes $*

}

function umount_sources() {

	grep -q ${escaped_sources} /proc/mounts && \
	awk "/${escaped_sources}/ {print \$2};" /proc/mounts | sort -r | xargs umount

}

function do_debootstrap() {

	debootstrap --include=${base},${live} edgy ${sources} ${mirror}

	log_it "$?" "do debootstrap"

	# HACK: This is a ugly hack for avoiding the debconf ask to configure 
        # the kernel package
	cat <<EOF > ${sources}/etc/kernel-img.conf
do_symlinks = yes
relative_links = yes
do_bootloader = no
do_bootfloppy = no
do_initrd = yes
link_in_boot = no
EOF

	# Force install and clean
	apt_get install 
	log_it "$?" "force apt-get install"
	apt_get clean
	log_it "$?" "force apt-get clean"
	
	# Umount pocfs inside sources, if any
	umount_sources
	log_it "$?" "force umount"

}

function create_manifests() {

	chroot ${sources} dpkg-query -W --showformat='${Package} ${Version}\n' > ${live_dir}livecd.ubuntu.manifest

	log_it "$?" "create manifest"

	filter="/tmp/filter"
	if [ -f "$filter" ]; then
		rm -f $filter
	fi
	for i in {$live}
	        do
	        echo "/$i/d" >> $filter
	done
	
	sed -f $filter < ${live_dir}livecd.ubuntu.manifest > ${live_dir}livecd.ubuntu.manifest-desktop 

	log_it "$?" "create manifest-desktop"

	rm -f $filter
}

function create_squashfs() {
	
	if [ -f "${live_dir}livecd.ubuntu.squashfs" ]; then
		rm -f ${live_dir}livecd.ubuntu.squashfs
	fi
	mksquashfs ${sources} ${live_dir}livecd.ubuntu.squashfs

	log_it "$?" "create squashfs"

}

function copy_files() {

	if [ -f "${live_dir}livecd.ubuntu.initrd-generic" ]; then
		rm -f ${live_dir}livecd.ubuntu.initrd-generic
	fi
	intrd=$(reaidlink ${sources}initrd.img)
	test -a $"initrd" && error "${sources}initrd.img not found"
	cp ${initrd} ${live_dir}livecd.ubuntu.initrd-generic 
	log_it "$?" "copy initrd"

	if [ -f "${live_dir}livecd.ubuntu.kernel-generic" ]; then
		rm -f ${live_dir}livecd.ubuntu.kernel-generic
	fi
	kernel=$(readlink ${sources}vmlinuz)
	test -a "$kernel" && error "${sources}vmlinuz not found"
	cp ${kernel} ${live_dir}livecd.ubuntu.kernel-generic 
	log_it "$?" "copy kernel"

}

function usage() {
	cat <<EOF
Usage:
	$0 [-h] [-d | --deboostrap] [-s | --squashfs] [-k | --keep-sources]

Options:
	-h                   Show this help
	-d, --debootstrap    Build from the packages
	-s, --squashfs       Create the squashfs image
        -k, --keep-sources   Keep the sources directory after finish
        -q, --quiet         Don't show any messages
        -k, --keep-sources   Keep the sources directory after finish


EOF
}

######## Here starts the script ########

must_be_root

get_config

while getopts "hdskqv" options
do
	case $options in
		h) usage
			exit 0
			;;
		d) debootstrap="yes"
			;;
		s) squashfs="yes"
			;;
		k) keep_sources="yes"
			;;
		q) quiet="yes"
			;;
		v) verbose="yes"
			;;
		*) usage
			exit 0
			;;
	esac
done


if [ "$quiet" = "yes" ]; then
	exec &> $log_file
fi

if [ "$verbose" = "yes" ]; then
	set -x
fi

if [ "$debootstrap" = "yes" ]; then
	do_debootstrap
fi

create_manifests

if [ "$squashfs" = "yes" ]; then
	create_squashfs
fi

copy_files

if [ "$keep_sources" != "yes" ]; then
	rm -fr ${sources}
fi

echo "Live system is ready to build!"

