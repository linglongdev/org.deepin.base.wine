# Foundation

Foundation 是玲珑的 base 镜像，包含用于运行容器的基础环境。

## 怎么构建

玲珑不允许推送相同版本的软件包，所以在构建之前先打开 create_rootfs/wine/version.sh 更改 VERSION 的值，更新版本号，

然后执行`./build_base.sh wine arm64`构建一个 arm 架构的 deepin_v23 版本的 base。

玲珑使用四位版本号规范，前三位和 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) 保持一致，第四位用于上游应用无变动，因其他问题需要重新打包时使用。

## 怎么添加软件包

打开 create_rootfs/wine/create_rootfs.sh 可以看到脚本中有两个变量，分别是 runtimePackages 和 developPackages，运行时的包添加到 runtimePackages 中，开发构建包添加到 developPackages。

## 目录结构参考

1. build_base.sh 主脚本，根据输入的发行版和架构创建对应的 rootfs 并打包成玲珑包

2. info.template.json, linglong.template.yaml 构建玲珑包需要的基本文件，一般不需要改动

3. create_rootfs 目录下可以创建多个子目录，用于构建不同发行版的 rootfs

   create_rootfs/$distro/create_rootfs.sh 用于创建某个发行版的 rootfs 目录的脚本

   create_rootfs/$distro/version.sh foundation 的版本号

   create_rootfs/$distro/arch.develop.packages.list 记录 foundation 开发环境包列表

   create_rootfs/$distro/arch.develop.packages.list 记录 foundation 运行环境包列表

4. hook.sh 在 rootfs 构建后执行的脚本

5. patch_rootfs 在构建 foudation 时会将该目录的文件复制到 rootfs 中

6. tools 放一些工具脚本

   tools/check-dev.bash 这个脚本用于检查 devel 多出的 so 文件不应该有 header 文件，减少构建环境和运行环境差异

   tools/check-lib.bash 这个脚本用于检查 develop 比 runtime 多出非 dev 的 lib 包，减少构建环境和运行环境差异，检查出的包是由构建工具或 dev 包引入的

   tools/check-package.bash 使用 appimage 的名单列表，检查缺少哪些包，仅作参考

   tools/check-library.bash 使用 appimage 的名单列表，检查缺少哪些库文件，仅作参考
