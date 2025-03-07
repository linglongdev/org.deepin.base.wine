# org.deepin.base.wine

这是玲珑关于wine项目的 base 镜像，包含用于运行容器的基础环境。

## 项目结构
main分支 是fork玲珑的base且同步更新
wine分支 基于玲珑base做的更改
需要操作wine的base则需要在拉取代码后切换到wine分支

## 怎么添加软件包
在项目的/wine/packages.conf文件中添加对应的包名

## 怎么添加仓库里没有的软件包
假设需要安装 `myapp.deb`（依赖已满足）：
手动下载myapp.deb放在指定位置
```bash
# 目录结构
.
├── mkosi.conf
├── mkosi.postinst
└── mkosi.extra/
    └── var/cache/apt/archives/
        └── myapp.deb
```
修改postinst脚本
 **mkosi.postinst**：
```bash
#!/bin/sh
set -ex
dpkg -i /var/cache/apt/archives/myapp.deb
```

## 怎么修改版本
修改version.bash文件

## (必要)玲珑工具版本过低的需要手动安装工具
把给出的ll-builder文件放在/usr/bin 目录下

## 怎么构建

然后执行`./build.bash amd64`构建一个 amd64 架构的base。

玲珑使用四位版本号规范，前三位和 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) 保持一致，第四位用于上游应用无变动，因其他问题需要重新打包时使用。

## 操作流程
操作流程共分为三步
第一步.制作base
第二步.制作runtime
第三部.应用打包
注:第二三步所需的文件在/test目录下

第一步:制作base.
- 拉取项目后,修改version.bash版本号,然后在项目根目录下执行`./build.bash amd64`等待构建完成
- 可以执行命令`cat ~/.cache/linglong-builder/states.json|jq`来查看你的base是否制作成功(有你修改的版本号信息即为成功)

第二步:制作runtime
- 切换到/test/runtime目录下,修改linglong.yaml第14行,改成你上一步制作的base的版本号(runtime的版本信息在第七行),执行命令:`ll-builder build --skip-pull-depend` 等待构建完成.若出错参考下方(常见错误解决方法)

第三步:制作应用
- 切换到/test/wxwork目录下,修改linglong.yaml第11,12行,改为你对应的base,runtime版本号,精确到第四位(发布只需前三位) 然后执行`ll-builder build --skip-pull-depend` 构建成功后执行`ll-builder run`启动应用

## 常见错误解决方法(欢迎补充)
在项目根目录下执行./build.bash amd64命令打base失败:
问题一: 没有mkosi工具
解决方案: sudo apt install mkosi
问题二： 仓库下载不到对应的软件包
解决方案：见上文（怎么添加仓库里没有的软件包）

构建runtime时候失败
问题一:看最后一行报错,如果找不到base提示unknow可能是base没有做成功。
如何查看base是否成功？执行命令cat ~/.cache/linglong-builder/states.json|jq 查看你base的版本是否存在
不存在跳会回上一步重新制作base
问题二:看最后一行报错,如果是failed to mount build base overlayfs  执行下载命令:sudo apt install fuse-overlayfs就好了
