# Wireguard

Wireguard Setup scripts writin in bash.

Main lines:
Because this script is intended to be run as root, every call will invite you to enter the correct command with a shell redirection to fill the corresponding configuration files.

However, a file named allKeys.txt will be the only automatically created file; This file will contain a text database of all generated private keys. So if you create a user key twice, the key will be the same.
allKeys.txt default permission will be 0600.


## Setup Wireguard

### Install wireguard

Ensure that kernel headers are installed

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

## Install the scripts

### Clone this repo

```
cd  /etc/wireguard/
git clone git@github.com:UrielCh/wireguard.git .
```

### Init config

Generate a random configuration environement, then customise it as you want.

```
./randconfig.sh > .env
nano .env
./init.sh
```

### Create a new client

Use ./add-key.sh

```bash
./add-key.sh client_id_fron_0_to_1021 client_name >> wg1.conf

example:
./add-key.sh 1 user01 >> wg1.conf
./add-key.sh 2 user02 >> wg1.conf
```
Read output for guide


### Display a key

```bash
./printKey.sh user-1
```

or 

```bash
./printKey.sh user-1 QR
```
to view it as a QR code

### List keys:

```bash
./list.sh 
```

## Enable / Disable debug

```bash
modprobe wireguard
echo 'module wireguard +p' > /sys/kernel/debug/dynamic_debug/control
# tail -F /var/log/messages /var/log/kern.log
journalctl -f
# or
dmesg -wH
```

Diasble:

```bash
echo 'module wireguard -p' > /sys/kernel/debug/dynamic_debug/control
```

## Sample

Create a serie of access key:

Sample generate bulk of keys in wg1.conf with IPs offset by 256 (only valid if with a MASK of 23 or more)

```bash
for X in {001..010};
  do ID=$(echo $X|sed -E s/^0+//);
  ./add-key.sh $((ID+256)) client-$X >> wg1.conf;
done
```

if your first IP os 10.0.0.0, this script will generate Acces with IPs 10.0.1.1, 10.0.1.2, 10.0.1.3 ...

## References

- [wireguard guide](https://github.com/pirate/wireguard-docs)
- [conf sample + ipV6](https://try.popho.be/wg.html)
- [debug Wireguard](https://gist.github.com/artizirk/5bc87e345f850a8a0724929e0436ef84)
- [debug Kernel](https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html)
