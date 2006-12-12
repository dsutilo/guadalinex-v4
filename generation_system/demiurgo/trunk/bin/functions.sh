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

get_repo_version () {
    SVN_ROOT=$1
    cd $SVN_ROOT > /dev/null
    svn up > /tmp/gensys-stuff.$USER.$DATE
    [ "$?" != "0" ] && echo " * * * * * Problems updating repository * * * * *" && exit 1
    REPO_VERSION=$(cat /tmp/gensys-stuff.$USER.$DATE | tail -1 | sed -e 's/.*\ //g' | sed -e 's/\.//g')
    cd - > /dev/null

    echo "r$REPO_VERSION"
}
