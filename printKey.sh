#!/bin/bash
. .env

# systemctl restart wg-quick@wg${WGID}.service
if [ "$#" -eq 0 ]
then
 echo usage:
 echo $0 username
 echo example:
 echo $0 uriel
 echo $0 uriel QR
 # \| qrencode -t ansiutf8
 exit 1
fi
# mkdir client
# for X in {1..30}; do ./printKey.sh  g$X > client/g$X.conf; done
#

DATA=$(grep -A3 \ user:${1}$ wg${WGID}.conf)

if [ -z "$DATA" ]
then
 echo no key for $1
 exit 1;
fi
IP=$(echo "$DATA" | grep -E -o 'AllowedIps\ =\ [0-9.]+' | cut -d\  -f3)
KEY=$(echo "$DATA" | grep -E -o 'PrivateKey\ =\ [A-Z/a-z0-9=+-]+' | cut -d\  -f3)
SRVPUB=$(cat wg${WGID}.conf | grep ^PrivateKey |  cut -d\  -f3 | wg pubkey)

cat > Tmp << EOF
[Interface]
# user:$1
PrivateKey = ${KEY}
Address = ${IP}/24

[Peer]
PublicKey = ${SRVPUB}
AllowedIPs = ${IP1}.${IP2}.${IP3}.0/24${EXTRA_ROUTE}
Endpoint = ${END_POINT}
PersistentKeepalive = 115

EOF
if [ "$#" -eq 1 ]
then
  cat Tmp
else
  cat Tmp | qrencode -t ansiutf8
fi
rm Tmp


>&2 echo
>&2 echo nano /etc/wireguard/wg${WGID}.conf
>&2 echo systemctl start wg-quick@wg${WGID}
>&2 echo systemctl enable wg-quick@wg${WGID}
