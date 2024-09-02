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
    runtime);;
    develop);;
    "") echo "enter an module, like ./create_rootfs.sh runtime amd64" && exit;;
    *) echo "unknow module \"$module\", supported module: runtime, develop" && exit;;
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
deepin-wine8-stable
deepin-wine-helper
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
    runtime)
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
