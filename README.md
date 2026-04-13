# OpenWrt for Cudy WR3000V2

基于 Lean 的 LEDE 源码，自动编译适用于 Cudy WR3000V2 (MediaTek MT7981) 的 OpenWrt 固件。

## 硬件规格

- **芯片**: MediaTek MT7981 (Filogic)
- **CPU**: Dual-core ARM Cortex-A53
- **内存**: 256MB DDR3
- **闪存**: 128MB SPI NAND
- **无线**: WiFi 6 (2.4G + 5G)
- **网口**: 4x Gigabit Ethernet

## 使用方法

### 1. 推送仓库到你的 GitHub

```bash
# 在终端执行以下命令：
git init
git add .
git commit -m "Initial OpenWrt build config for Cudy WR3000V2"
git remote add origin https://github.com/Flyfash1024/openwrt-cudy-wr3000v2.git
git branch -M main
git push -u origin main
```

或者直接在 GitHub 上创建新仓库，把这个文件夹上传上去。

### 2. 触发编译

1. 打开 https://github.com/Flyfash1024/openwrt-cudy-wr3000v2/actions
2. 点击 "Build OpenWrt for Cudy WR3000V2"
3. 点击 "Run workflow" → "Run workflow"

### 3. 下载固件

编译完成后（约 1-2 小时），在 Actions 页面点击对应的 run，然后下载 artifacts。

## 刷机教程

1. 断电，按住 **Reset** 按钮
2. 通电，等待指示灯闪烁后松开
3. 电脑连接路由器 LAN 口
4. 访问 `192.168.1.1` 进入恢复模式
5. 上传固件

**注意**：刷机有风险，请谨慎操作。建议先备份原厂固件。

## 包含的软件包

- LuCI Web 界面
- LuCI App Opkg (软件包管理)
- Argon 主题
- WPA3/加密无线驱动

## 自动构建

- 每天 UTC 2:00 自动编译
- 也可以手动触发
