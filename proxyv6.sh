#!/bin/bash

YUM=$(which yum)

if [ "$YUM" ]; then
    echo "🔧 Đang bật IPv6 trong sysctl..."
    echo > /etc/sysctl.conf
    tee -a /etc/sysctl.conf <<EOF
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
EOF
    sysctl -p

    IPC=$(curl -4 -s icanhazip.com | cut -d"." -f3)
    IPD=$(curl -4 -s icanhazip.com | cut -d"." -f4)

    # IPv6 prefix của bạn
    PREFIX="2600:1900:4001:52d:0:3:0"

    # Gán địa chỉ IPv6 cho card mạng thông qua ifcfg-eth0 (dành cho CentOS 7 hoặc bạn đã bật scripts cũ)
    tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
IPV6INIT=yes
IPV6_AUTOCONF=no
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
IPV6ADDR=${PREFIX}:$IPD:0000/64
IPV6_DEFAULTGW=${PREFIX}:1
EOF

    service NetworkManager restart
    echo "✅ Đã cấu hình IPv6 thành công: ${PREFIX}:$IPD:0000/64"
fi
