#!/bin/ash

# Hosts 自动合并脚本

echo "开始更新合并 hosts 文件..."

# 删除空行
echo "删除空行..."
sed -i '/^$/d' /etc/hosts

# 删除现有的 GitHub520 Host 加速规则条目
echo "删除现有的 GitHub520 Host 加速规则条目..."
sed -i '/# GitHub520 Host Start/,/# GitHub520 Host End/d' /etc/hosts

# 拉取并合并 GitHub520 Host 的 hosts 文件
echo "拉取并合并 GitHub520 Host 的 hosts 文件..."
curl https://raw.hellogithub.com/hosts >> /etc/hosts

# 删除空行
echo "删除空行..."
sed -i '/^$/d' /etc/hosts

# 删除多余注释信息
echo "删除多余注释信息..."
sed -i '/!/d' /etc/hosts

echo "hosts 文件更新合并完成！"

# 将 hosts 文件编码转换为 UTF-8
#echo "将 hosts 文件编码转换为 UTF-8..."
#iconv -f ANSI -t UTF-8 /etc/hosts > /tmp/hosts.tmp && mv /tmp/hosts.tmp /etc/hosts

#echo "hosts 文件编码已转换为 UTF-8！"

# 检查是否存在 OpenClash 的启动脚本
if [ -f "/etc/init.d/openclash" ]; then
    # 如果存在 OpenClash 的启动脚本，则重启 OpenClash
    echo "检测到 OpenClash 存在，正在重启 OpenClash..."
    /etc/init.d/openclash restart
    echo "已重启 OpenClash 和 Dnsmasq，Hosts 已生效！"
else
    # 如果不存在 OpenClash 的启动脚本，则直接重启 dnsmasq
    echo "未检测到 OpenClash，正在重启 Dnsmasq..."
    /etc/init.d/dnsmasq restart
    echo "已重启 Dnsmasq，Hosts 已生效！"
fi

