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


