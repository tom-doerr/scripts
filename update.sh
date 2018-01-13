#!/usr/bin/env bash

sudo apt-get update
kernel_release="$(uname -r | cut --complement -d'.' -f3)"
kernel_release_versions="$(apt-cache search linux-image-${kernel_release})"
kernel_release_versions_generic="$(grep linux-image-"${kernel_release_version}".*-generic <<< "$kernel_release_versions")"
newest_kernel_of_release="$(echo "$kernel_release_versions_generic" | tail -n1 | cut -d' ' -f1 )"

sudo apt-get install $newest_kernel_of_release

newest_kernel_of_release_headers=${newest_kernel_of_release/image/headers}

sudo apt-get install $newest_kernel_of_release_headers

sudo apt-get dist-upgrade
