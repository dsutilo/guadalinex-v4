#! /bin/sh

mkemptydir () {
	rm -rf "$1"
	mkdir -p "$1"
}

confirm () {
	printf ' [yN] '
	read yesno
	yesno="$(printf %s "$yesno" | tr A-Z a-z)"
	case $yesno in
		y|yes)
			return 0
			;;
		*)
			return 1
			;;
	esac
}

get_svn_rev () {
	SVN_ROOT_DIR=$1
	cat $SVN_ROOT_DIR/.svn/entries | grep committed-rev | sed -e 's/\"//g' | sed -e 's/.*\=//g'
}
