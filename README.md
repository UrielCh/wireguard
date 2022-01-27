# wireguard

## install wireguard
```
apt install pve-headers-$(uname -r) wireguard
```
## clone this repo

```
cd  /etc/wireguard/
git clone git@github.com:UrielCh/wireguard.git .
```

## init config

```
cp .env.sample .env
nano .env
./init.sh
```


## enable debug

```bash
modprobe wireguard
echo module wireguard +p > /sys/kernel/debug/dynamic_debug/control
tail -F /var/log/messages /var/log/kern.log
```