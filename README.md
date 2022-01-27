# wireguard

Wireguard Setup scripts writin in bash.

## Setup Wireguard

### install wireguard

ensure that kernel headers are installed

* debian 10 and older (ex: buster)
```
echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' > /etc/apt/sources.list.d/buster-backports.list"
```

* for proxmox:
```
apt install pve-headers-$(uname -r) wireguard
```

* for debian:
```
apt install -y linux-headers-$(uname -r) wireguard
```

### Install extra dependences

```bash
apt-get install qrencode
```

## install the scripts

### clone this repo

```
cd  /etc/wireguard/
git clone git@github.com:UrielCh/wireguard.git .
```

### init config

generate a random configuration, then customise it

```
./randconfig.sh > .env
nano .env
./init.sh
```

### create a new client

use ./add-key.sh

```bash
./add-key.sh client_id_fron_0_to_1021 client_name >> wg1.conf

example:
./add-key.sh 1 user01 >> wg22.conf
./add-key.sh 2 user02 >> wg22.conf
```
Read output for guide


### display a key

```bash
./printKey.sh user-1
```

or 

```bash
./printKey.sh user-1 QR
```
to view it as a QR code

### list keys:

```bash
./list.sh 
```

## enable / disable debug

```bash
modprobe wireguard
echo 'module wireguard +p' > /sys/kernel/debug/dynamic_debug/control
# tail -F /var/log/messages /var/log/kern.log
sudo journalctl -f
```

Diasble:

```bash
echo 'module wireguard -p' > /sys/kernel/debug/dynamic_debug/control
```

## sample

Create a serie of access key:

Sample generate bulk of keys in wg1.conf with IPs offset by 256 (only valid if with a MASK of 23 or more)

```bash
for X in {001..010}; do ID=$(echo $X|sed -E s/^0+//); ./add-key.sh $((ID+256)) client-$X >> wg1.conf; done
```

if your first IP os 10.0.0.0, this script will generate Acces with IPs 10.0.1.1, 10.0.1.2, 10.0.1.3 ...

## references

- [wireguard guide](https://github.com/pirate/wireguard-docs)
- [conf sample + ipV6](https://try.popho.be/wg.html)
- [debug Wireguard](https://gist.github.com/artizirk/5bc87e345f850a8a0724929e0436ef84)
- [debug Kernel](https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html)
