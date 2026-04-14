# WR3000V2 OpenWrt 编译项目

基于 Cudy WR3000V2 (R116) 固件提取信息定制的 OpenWrt 编译配置。

## 设备信息

| 项目 | 值 |
|------|-----|
| 设备型号 | Cudy WR3000V2 |
| 芯片方案 | Hisilicon Hi (海思) |
| 目标平台 | hisilicon/luofu |
| 开发板 | ax3000_lite |
| OpenWrt 版本 | 22.03.6 |

## 包含功能

- ✅ WPA2 PEAP 客户端模式（无线网卡模式）
- ✅ 2.4G/5G 双频 AP
- ✅ 有线 LAN/WAN
- ✅ LuCI Web 界面

## 目录结构

```
openwrt-wr3000v2/
├── build.sh          # 编译脚本
├── files/            # 预设配置文件
│   └── etc/config/
│       ├── wireless  # 无线配置
│       └── network  # 网络配置
└── README.md         # 说明文档
```

## 快速开始

### 1. 在有编译环境的机器上运行

```bash
# 克隆项目
git clone <this-repo>
cd openwrt-wr3000v2

# 运行编译
chmod +x build.sh
./build.sh
```

### 2. 等待编译完成（约 1-2 小时，首次编译）

### 3. 固件位置
```
openwrt/bin/targets/hisilicon/luofu/
```

## 配置说明

### 修改无线 SSID/密码

编辑 `files/etc/config/wireless`：

```bash
# STA 客户端模式配置
config wifi-iface
    option ssid '你的SSID'           # 修改为目标网络
    option identity 'username'       # PEAP 用户名
    option password 'password'       # PEAP 密码
```

### 修改 LAN IP

编辑 `files/etc/config/network`：
```bash
config interface 'lan'
    option ipaddr '192.168.1.1'    # 修改 IP
```

## 编译要求

- Ubuntu 20.04+ / Debian 11+
- 至少 20GB 磁盘空间
- 至少 4GB 内存
- 需要稳定网络（下载依赖）

## 常见问题

### Q: 编译失败怎么办？
```bash
# 清理后重试
cd openwrt
make clean
./build.sh
```

### Q: 如何只更新配置不重新编译？
```bash
# 修改配置后
cd openwrt
make target/linux/compile V=s
```

### Q: 固件怎么刷入？
1. 通过 U-Boot 刷入
2. 通过 TTL 串口刷入
3. 原厂 Web 界面刷入（需适配）

## 参考资料

- [OpenWrt 官方文档](https://openwrt.org/docs/guide-developer/build-system/use-buildsystem)
- [海思方案支持](https://openwrt.org/docs/techref/target/hisilicon)
- [WR3000V2 固件分析](../extracted/README.md)

## 更新日志

- 2026-04-14: 初始版本，基于 R116 固件
