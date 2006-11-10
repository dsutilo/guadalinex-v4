#!/bin/bash

# Define variables
mirror="file:///var/mirror/ubuntu/"
live_dir="/var/cdimage/live/edgy/ubuntu/current/"

sources="/tmp/sources/"
escaped_sources=$(echo $sources | sed 's|/|\\/|g')

base="ubuntu-desktop,linux-image-generic"
live="casper,ubiquity-frontend-gtk,ubiquity-ubuntu-artwork,xfsprogs,jfsutils,ntfsprogs,discover1,xresprobe,laptop-detect"

# Parameters vars to default values
debootstrap="yes"
squashfs="yes"
keep_sources="no"

# Functions
function error() {

	echo "Error: $*"
	exit

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
	apt_get clean
	
	# Umount pocfs inside sources, if any
	umount_sources
}

function create_manifests() {

	chroot ${sources} dpkg-query -W --showformat='${Package} ${Version}\n' > ${live_dir}livecd.ubuntu.manifest

	filter="/tmp/filter"
	if [ -f "$filter" ]; then
		rm -f $filter
	fi
	for i in {$live}
	        do
	        echo "/$i/d" >> $filter
	done
	
	sed -f $filter < ${live_dir}livecd.ubuntu.manifest > ${live_dir}livecd.ubuntu.manifest-desktop 
	rm -f $filter
}

function create_squashfs() {
	
	if [ -f "${live_dir}livecd.ubuntu.squashfs" ]; then
		rm -f ${live_dir}livecd.ubuntu.squashfs
	fi
	mksquashfs ${sources} ${live_dir}livecd.ubuntu.squashfs

}

function copy_files() {

	if [ -f "${live_dir}livecd.ubuntu.initrd-generic" ]; then
		rm -f ${live_dir}livecd.ubuntu.initrd-generic
	fi
	intrd=$(reaidlink ${sources}initrd.img)
	test -a $"initrd" && error "${sources}initrd.img not found"
	cp ${initrd} ${live_dir}livecd.ubuntu.initrd-generic 

	if [ -f "${live_dir}livecd.ubuntu.kernel-generic" ]; then
		rm -f ${live_dir}livecd.ubuntu.kernel-generic
	fi
	kernel=$(readlink ${sources}vmlinuz)
	test -a "$kernel" && error "${sources}vmlinuz not found"
	cp ${kernel} ${live_dir}livecd.ubuntu.kernel-generic 

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


EOF
}

########

while getopts "hdsk" options
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
		*) usage
			exit 0
			;;
	esac
done


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

