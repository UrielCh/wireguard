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
