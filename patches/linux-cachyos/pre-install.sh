#! /bin/bash

# Apply 0001-add-bmi260-support-for-gpd-win-mini-2024.patch
patch -p1 < 0001-add-bmi260-support-for-gpd-win-mini-2024.patch

# Using sed enable linux-cachyos-deckify options
sed -i 's/:_tcp_bbr3:=no/:_tcp_bbr3:=yes/' linux-cachyos-deckify/PKGBUILD
sed -i 's/:_processor_opt:=/:_processor_opt:=native_amd/' linux-cachyos-deckify/PKGBUILD
# Using CN mirrors for kernel
sed -i 's/cdn.kernel.org\/public\/linux/mirrors.tuna.tsinghua.edu.cn/' linux-cachyos-deckify/PKGBUILD