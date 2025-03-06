# org.deepin.base.wine

这是玲珑关于wine项目的 base 镜像，包含用于运行容器的基础环境。

## 项目结构
main分支 是fork玲珑的base且同步更新
wine分支 基于玲珑base做的更改
需要操作wine的base则需要在拉取代码后切换到wine分支

## 怎么添加软件包
在项目的/wine/packages.conf文件中添加对应的包名

## 怎么修改版本
修改version.bash文件

## (必要)玲珑工具版本过低的需要手动安装工具
把给出的ll-builder文件放在/usr/bin 目录下

## 怎么构建

然后执行`./build_base.sh amd64`构建一个 amd64 架构的base。

玲珑使用四位版本号规范，前三位和 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) 保持一致，第四位用于上游应用无变动，因其他问题需要重新打包时使用。
