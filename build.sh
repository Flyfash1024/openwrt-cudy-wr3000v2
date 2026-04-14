#!/bin/bash
#
# WR3000V2 OpenWrt 编译脚本 (简化版)
# 支持 WPA2 PEAP 客户端模式
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENWRT_DIR="${SCRIPT_DIR}/openwrt"

# 配置参数
TARGET_SYSTEM="hisilicon"
SUBTARGET="luofu"
TARGET_PROFILE="ax3000_lite"
OPENWRT_VERSION="v22.03.6"

echo "========================================="
echo "WR3000V2 OpenWrt 编译脚本"
echo "========================================="
echo "目标平台: ${TARGET_SYSTEM}/${SUBTARGET}"
echo "设备: ${TARGET_PROFILE}"
echo ""

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 1. 安装编译依赖
install_deps() {
    log_info "[1/6] 安装编译依赖..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git build-essential libssl-dev libncurses5-dev \
            gawk flex bison libelf-dev zlib1g-dev libncursesw5-dev \
            python3-distutils luajit liblua5.3-dev ccache subversion \
            libzstd-dev
    fi
    
    log_info "依赖安装完成"
}

# 2. 下载 OpenWrt 源码
clone_openwrt() {
    log_info "[2/6] 下载 OpenWrt 源码..."
    
    if [ -d "${OPENWRT_DIR}" ]; then
        log_warn "源码目录已存在，跳过下载"
        return
    fi
    
    git clone https://github.com/openwrt/openwrt.git -b ${OPENWRT_VERSION} --depth 1 ${OPENWRT_DIR}
    
    log_info "源码下载完成"
}

# 3. 配置
configure() {
    log_info "[3/6] 配置编译选项..."
    
    cd ${OPENWRT_DIR}
    
    # 更新 feeds
    ./scripts/feeds update -a
    
    # 安装必要包
    ./scripts/feeds install -a
    
    # 复制预设配置文件
    if [ -d "${SCRIPT_DIR}/files" ]; then
        cp -r ${SCRIPT_DIR}/files/* ${OPENWRT_DIR}/files/
        log_info "已复制配置文件到 files/"
    fi
    
    # 生成配置文件
    cat > .config << 'EOF'
CONFIG_TARGET_hisilicon=y
CONFIG_TARGET_hisilicon_luofu=y
CONFIG_TARGET_hisilicon_luofu_ax3000_lite=y
CONFIG_PACKAGE_wpad-openssl=y
CONFIG_PACKAGE_wpa-supplicant=y
CONFIG_PACKAGE_libiwinfo-lua=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-app-wireguard=y
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
EOF

    log_info "配置完成"
}

# 4. 编译
build() {
    log_info "[4/6] 开始编译..."
    
    cd ${OPENWRT_DIR}
    
    # 下载依赖
    make download -j$(nproc)
    
    # 编译
    make -j$(nproc) V=s
    
    log_info "编译完成"
}

# 5. 输出
output() {
    log_info "[5/6] 编译输出..."
    
    FIRMWARE_DIR="${OPENWRT_DIR}/bin/targets/${TARGET_SYSTEM}/${SUBTARGET}"
    
    if [ -d "${FIRMWARE_DIR}" ]; then
        echo ""
        echo "固件文件:"
        find ${FIRMWARE_DIR} -name "*.bin" -o -name "*.img" | while read f; do
            size=$(du -h "$f" | cut -f1)
            echo "  $size - $(basename $f)"
        done
        
        echo ""
        log_info "固件目录: ${FIRMWARE_DIR}"
    else
        log_error "编译输出目录不存在"
    fi
}

# 主流程
main() {
    install_deps
    clone_openwrt
    configure
    build
    output
    
    echo ""
    echo "========================================="
    log_info "编译完成!"
    echo "========================================="
    echo ""
    echo "使用说明:"
    echo "1. 将编译的固件刷入设备"
    echo "2. 登录后修改 /etc/config/wireless 中的 SSID 和密码"
    echo "3. 重启网络: /etc/init.d/network restart"
    echo ""
}

main "$@"
