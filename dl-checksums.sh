#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/stefanprodan/timoni/releases/download

dl()
{
    local ver=$1
    local lhashes=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-"tar.gz"}
    local platform="${os}_${arch}"
    local file="timoni_${ver}_${platform}.${archive_type}"

    # https://github.com/stefanprodan/timoni/releases/download/v0.13.1/timoni_0.13.1_linux_amd64.tar.gz
    local url="${MIRROR}/v${ver}/${file}"

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(fgrep $file $lhashes | awk '{ print $1 }')
}

dl_ver() {
    local ver=$1

    local f="timoni_${ver}_checksums.txt"
    local lhashes="${DIR}/${f}"

    # https://github.com/stefanprodan/timoni/releases/download/v0.13.1/timoni_0.13.1_checksums.txt
    local url="${MIRROR}/v${ver}/${f}"

    if [ ! -e "${lhashes}" ];
    then
        curl -sSLf -o $lhashes $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl $ver $lhashes darwin amd64
    dl $ver $lhashes darwin arm64
    dl $ver $lhashes linux amd64
    dl $ver $lhashes linux arm64
    dl $ver $lhashes windows amd64 zip
}

dl_ver ${1:-0.13.1}
