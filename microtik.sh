#!/bin/bash
# ایجاد فایل اسکریپت microtik.sh
cat << 'EOF' > microtik.sh
#!/bin/bash
# نصب coreutils برای اطمینان از وجود دستورات ضروری
sudo apt-get update && sudo apt-get install -y coreutils

# دانلود فایل MikroTik
wget https://download.mikrotik.com/routeros/7.16.2/chr-7.16.2.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
mount -o loop,offset=512 chr.img /mnt && \
ADDRESS=\`ip addr show eth0 | grep global | cut -d' ' -f 6 | head -n 1\` && \
GATEWAY=\`ip route list | grep default | cut -d' ' -f 3\` && \
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=root password=xxxxxx"
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/vda && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger
EOF

# تغییر مجوز اجرایی فایل
chmod +x microtik.sh

# اجرای فایل
./microtik.sh
