#!/bin/bash
USAGE="Usage: ./rpi-backup.sh -b BOOTDIR -r ROOTDIR [-n NAME] DESTINATION"
OPTIND=1

bootdir=""
rootdir=""
dest=""
verbose=""
name="rpi"

SHORT=b:r:n:v
LONG=boot:root:name:verbose
OPTS=$(getopt -o $SHORT --long $LONG --name "$0" -- "$@")

eval set -- "$OPTS"

while [[ $# -gt 0 ]] ; do
    case $1 in
        -r|--root)
            rootdir="$2"
            shift 2
        ;;
        -b|--boot)
            bootdir="$2"
            shift 2
        ;;
        -n|--name)
            name="$2"
            shift 2
        ;;
        -v|--verbose)
            verbose="-v"
            shift
        ;;
        --)
            shift
        ;;
        *)
            if [[ -z $dest ]] ; then
                dest="$1"
                shift
            else
                >&2 echo "ERROR Invalid parameters $1"
                echo "$USAGE"
                exit 3
            fi
        ;;
    esac
done
echo $dest
date=$(date -I)

if [[ -z $dest ]] ; then
    >&2 echo "ERROR A destination must be provided"
    echo "$USAGE"
    exit 1
fi
if [[ ! -z $bootdir ]] ; then
    echo tar czf "${dest}${name}-${date}-boot.tar.gz ${verbose} --one-file-system -C ${bootdir} ."
    tar czf "${dest}${name}-${date}-boot.tar.gz" ${verbose} --one-file-system -C "${bootdir}" "."
fi
if [[ ! -z $rootdir ]] ; then
    echo tar czpf "${dest}${name}-${date}-root.tar.gz ${verbose} --xattrs --one-file-system -C ${rootdir} ."
    tar czpf "${dest}${name}-${date}-root.tar.gz" ${verbose} --xattrs --one-file-system -C "${rootdir}" "."
elif [[ -z $bootdir ]] ; then
    echo "$USAGE"
    exit 14
fi
