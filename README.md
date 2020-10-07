# luci-app-seu-net
- openwrt 东南大学校园网登录助手


- 编译

    ```bash
    #进入OpenWRT/LEDE源码package目录
    cd package
    #克隆插件源码
    git clone https://github.com/quzard/luci-app-seu-net.git
    #返回上一层目录
    cd ..
    #配置
    make menuconfig
    #在luci->application选中插件luci-app-seu-net,编译
    #单独编译
    make package/luci-app-seu-net/compile V=99
    ```
