# frida-gadget-ios

### 说明
用于创建frida gadget的越狱插件，使用script-directory模式。会拉取最新的frida gadget dylib用于打包deb。

### 环境
- curl
- wget
- 需要本地有theos环境，并有THEOS环境变量。

### 使用
运行 make_package.sh，打包文件放在out目录。
