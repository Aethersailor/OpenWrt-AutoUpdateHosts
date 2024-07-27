#!/bin/ash

# 拉取 Anti-AD 去广告规则和 GitHub520 加速规则，并添加对应的拉取命令至计划任务

# 定义两个命令和时间
CMD1="sed -i '/^$/d; /# GitHub520 Host Start/,/# GitHub520 Host End/d' /etc/hosts && curl -s https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts >> /etc/hosts && sed -i '/^$/d; /!/d' /etc/hosts"
TIME1="30 4 * * *"

CMD2="curl -s https://anti-ad.net/anti-ad-for-dnsmasq.conf -o /tmp/dnsmasq.d/anti-ad-for-dnsmasq.conf"
TIME2="40 4 * * *"

# 修改 dnsmasq 配置文件，取消“忽略 hosts 文件”的设定
DNSMASQ_CONF="/etc/config/dhcp"
echo "修改 dnsmasq 配置文件，取消“忽略 hosts 文件”的设定..."
sed -i '/option nohosts/d' "$DNSMASQ_CONF"

# 获取当前 crontab 内容
CRONTAB_CONTENT=$(crontab -l 2>/dev/null)

# 删除已存在的命令行
CRONTAB_CONTENT=$(echo "$CRONTAB_CONTENT" | grep -v -F "$CMD1")
CRONTAB_CONTENT=$(echo "$CRONTAB_CONTENT" | grep -v -F "$CMD2")

# 添加新命令到 crontab
(echo "$CRONTAB_CONTENT"; echo "$TIME1 $CMD1"; echo "$TIME2 $CMD2") | crontab -

echo "计划任务条目已更新。"

# 立即执行第一个命令
echo "立即执行第一个命令..."
eval "$CMD1"

# 立即执行第二个命令
echo "立即执行第二个命令..."
eval "$CMD2"

echo "规则文件已拉取完成。"

