#!/bin/bash
chmod +x /path/to/mikrotik.sh  # دستور برای دادن دسترسی اجرایی به فایل
# بررسی دسترسی به دستور sleep
command -v sleep >/dev/null 2>&1 || { echo "sleep command not found"; exit 1; }

# دانلود و استخراج فایل MikroTik RouterOS
wget https://download.mikrotik.com/routeros/6.49.18/chr-6.49.18.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
mount -o loop,offset=512 chr.img /mnt && \

# گرفتن آدرس IP و Gateway
ADDRESS=`ip addr show eth0 | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \

# تنظیمات MikroTik
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=root password=xxxxxx"

# فعال‌سازی sysrq و نوشتن به دیسک
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/vda && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \

# استفاده از bash به جای sleep برای تأخیر
echo "Sleep 5 seconds"
for i in {1..5}; do
    echo -n "."
    sleep 1
done
echo ""

# ریبوت سیستم
echo "Ok, reboot"
echo b > /proc/sysrq-trigger
