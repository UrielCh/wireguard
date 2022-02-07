#!/bin/bash
. .env
. common.sh

# systemctl restart wg-quick@wg${WGID}.service
if [ "$#" -eq 0 ]
then
 echo usage:
 echo $0 username
 echo example:
 echo $0 user-1
 echo $0 user-1 QR
 # \| qrencode -t ansiutf8
 exit 1
fi

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
Address = ${IP}/${MASK}
DNS = ${CLIENT_DNS}

[Peer]
PublicKey = ${SRVPUB}
AllowedIPs = ${IP_FIRST}/${MASK}${EXTRA_ROUTE}
Endpoint = ${END_POINT}
PersistentKeepalive = ${PersistentKeepalive}

EOF
if [ "$#" -eq 1 ]
then
  cat Tmp
else
  cat Tmp | qrencode -t ansiutf8
fi
rm Tmp


>&2 echo
>&2 echo nano /etc/wireguard/wg${WGID}.conf\;
>&2 echo systemctl start wg-quick@wg${WGID}\;
>&2 echo systemctl enable wg-quick@wg${WGID}\;
OFFSET=$(($(maskSize ${MASK})-2))
SRV=$(trIP $IP_FIRST $OFFSET)
>&2 echo ping -c 3 ${SRV}\;
