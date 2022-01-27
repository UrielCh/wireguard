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

## references

- [conf sample + ipV6](https://try.popho.be/wg.html)
- [debug Wireguard](https://gist.github.com/artizirk/5bc87e345f850a8a0724929e0436ef84)
- [debug Kernel](https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html)
