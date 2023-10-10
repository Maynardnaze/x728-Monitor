#!/usr/bin/env bash
if [ `whoami` != "root" ] || [ "$UID" != 0 ]; then
  echo "I must be run with sudo."
  exit 1;
fi
cd ~
git clone https://github.com/geekworm-com/x728-script
cd x728-script
chmod +x *.sh
cp -f ./x728-pwr.sh                /usr/local/bin/
cp -f ./x728-v2.x-softsd.sh        /usr/local/bin/x728-softsd.sh
apt-get install -y python3-smbus python3-rpi.gpio

echo "alias x728off='sudo /usr/local/bin/x728-softsd.sh'" >>   ~/.bashrc
source ~/.bashrc


echo -e 'i2c-dev' >> /etc/modules
modprobe -a i2c-dev
echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
sed -i '$ i echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device' /etc/rc.local
sed -i '$ i hwclock -s' /etc/rc.local
sleep 2
hwclock -w

cp x728.conf /etc/
cp x728-monitor.py /usr/bin/x728-monitor.py
cp x728Monitor.service  /etc/systemd/system/
chmod u+rwx /etc/systemd/system/x728Monitor.service
systemctl enable --now x728Monitor.service
