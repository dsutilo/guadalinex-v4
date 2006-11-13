#!/bin/bash

#
# Description:
#   GLIG is a Guadalinex Live Image Generator.
#  
#   This program generate a chroot system from a debian repository in order
#   to create a squashfs compressed image of that system for being able to run
#   as a live GNU/Linux system.
#
# Authors: 
#   Juan Jesús Ojeda Croissier (juanje) <jojeda@emergya.es>   
#
# Last modified: 
#   $Date$ 
#   $Author$
#



revision="$Rev$"
log_file="/var/log/glig-$(date +%Y%m%d%H%M).log"

# Functions
function error() {

    echo "Error: $*" >&2 
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
            echo "${msg} ($(date +'%b %e %H:%M:%S')): Fail" | tee -a $log_file >&2
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
    for i in $(echo $live | tr ',' ' ' );
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
    initrd=$(readlink ${sources}initrd.img)
    test -f "${sources}${initrd}" || error "${sources}initrd.img not found"
    cp ${sources}${initrd} ${live_dir}livecd.ubuntu.initrd-generic 
    log_it "$?" "copy initrd"

    if [ -f "${live_dir}livecd.ubuntu.kernel-generic" ]; then
    	rm -f ${live_dir}livecd.ubuntu.kernel-generic
    fi
    kernel=$(readlink ${sources}vmlinuz)
    test -f "${sources}${kernel}" || error "${sources}vmlinuz not found"
    cp ${sources}${kernel} ${live_dir}livecd.ubuntu.kernel-generic 
    log_it "$?" "copy kernel"

}

function usage() {

    cat <<EOF
Usage:
    $0 [-h] [-d | --no-deboostrap] [-s | --no-squashfs] [-k | --keep-sources] \
       [-q | --quiet] [-v | --verbose]

Options:
    -h                     Show this help
    -d, --no-debootstrap   Not to build from the packages
    -s, --no-squashfs      Not to create the squashfs image
    -k, --keep-sources     Keep the sources directory after finish
    -q, --quiet            Don't show any messages
    -v, --verbose          Show more information about the execution

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
        d) debootstrap="no"
            ;;
        s) squashfs="no"
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

# vim:ai:et:sts=4:tw=80:sw=4:
