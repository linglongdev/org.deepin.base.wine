#!/bin/bash

# Copyright (c) 2022. Uniontech Software Ltd. All rights reserved.
#
# Author:     wurongjie <wurongjie@deepin.org>
#
# Maintainer: wurongjie <wurongjie@deepin.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

module="$1"
arch="$2"

case $module in
    binary);;
    develop);;
    "") echo "enter an module, like ./create_rootfs.sh runtime amd64" && exit;;
    *) echo "unknow module \"$module\", supported module: binary, develop" && exit;;
esac


case $arch in
    amd64);;
    arm64);;
    loongarch64);;
    "") echo "enter an architecture, like ./create_rootfs.sh runtime amd64" && exit;;
    *) echo "unknow arch \"$arch\", supported arch: amd64, arm64, loongarch64" && exit;;
esac
runtimePackages=(
apt
dpkg
ca-certificates
binutils
xz-utils
libssl1.1
vim
7zip
libglib2.0-0
gsettings-desktop-schemas
x11-utils
procps
rsync
fonts-wqy-microhei
)
# deepin-wine8-stable相关依赖
runtimePackages+=(
libasound2
libc6
libdbus-1-3
libgphoto2-6
libgphoto2-port12
libpulse0
libudev1
libunwind8
libusb-1.0-0
libwayland-client0
libx11-6
libxext6
ocl-icd-libopencl1
libasound2-plugins
libncurses6
)
# deepin-wine-helper的相关依赖
runtimePackage+=(
p7zip-full  
libc6  
libdtkcore5  
libdtkgui5  
libdtkwidget5  
libgcc1  
libgl1  
libqt5core5a  
libqt5gui5  
libqt5widgets5  
libstdc++6  
libx11-6  
fonts-noto-cjk  
python3-dbus  
deepin-elf-verify
)

# 复制runtimePackage
developPackages=("${runtimePackages[@]}")
# 将数组拼接成字符串
function join_by {
  local d=${1-} f=${2-}
  if shift 2; then printf %s "$f" "${@/#/$d}"; fi
}

include=""
case $module in
    binary)
        include=$(join_by , "${runtimePackages[@]}")
        ;;
    develop)
        include=$(join_by , "${developPackages[@]}")
        ;;
esac

# shellcheck disable=SC2001
echo "$include"|sed 's|,|\n|g' > "$module.include.list"

workdir=$(dirname "${BASH_SOURCE[0]}")
mmdebstrap --variant=minbase \
        --architectures="$arch" \
        --include="$include" \
        "" "$module.tar" - < "$workdir/sources.list"

# 将tar包解压成目录
rm -rf "$module" || true
mkdir -p "$module/files"
tar -xvf "$module.tar" -C "$module/files" || true # 不知为何，解压到最后会报错但不影响使用
cp "$workdir/ldconfig/ldconfig_$arch" "$module/files/sbin/"
rm "$module.tar"
