#!/bin/bash
# systemctl restart wg-quick@wg1.service
# ./printKey.sh  david-phone | qrencode -t ansiutf8
. .env
. utils.sh

MAX_OFFSET=$(($(maskSize ${MASK})-3))

# Sample generat bunk of keys + offset IP by 256
# for X in {003..006}; do ID=$(echo $X|sed -E s/^0+//); ./add-key.sh $((ID+256)) client-$X >> wg1.conf; done

if [ "$#" -ne 2 ]
then
 >&2 echo usage:
 >&2 echo $0 ID[0-${MAX_OFFSET}] name  \>\> wg${WGID}.conf
 >&2 echo
 >&2 echo example:
 >&2 echo $0 1 user01 \>\> wg${WGID}.conf
 >&2 echo $0 2 user02 \>\> wg${WGID}.conf
 exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]] ; then echo "error: first argument \"$1\" id must be a number between 1 and ${MAX_OFFSET} " >&2; exit 1; fi;
if   [[ $2 =~ ^[0-9]+$ ]] ; then echo "error: second argument \"$2\" username can not be a number" >&2; exit 1; fi;

if [[ ! $1 -gt 0 ]]; then echo first param must must be a number 1-${MAX_OFFSET}; exit; fi
if [[ ! $1 -le $MAX_OFFSET ]]; then echo first param must must be a number 1-${MAX_OFFSET}; exit; fi

CLIENT_IP=$(trIP $IP_FIRST $1)
REGEXP=$(echo ${CLIENT_IP}/${MASK} | sed s/\\./\\\\\./g)
C1=$(grep -c ${REGEXP} wg${WGID}.conf)

if [ $C1 -ne 0 ]
then
  USERNAME=$(grep -B4 ${REGEXP} wg${WGID}.conf  | grep ' user:' | cut -d: -f2)
  >&2 echo IP ${CLIENT_IP} already taken by user ${USERNAME}
  exit 1
fi

C2="$(grep -c user:$2$ wg${WGID}.conf)"

if [ $C2 -ne 0 ]
then
  IP="$(grep -A4 user:$2$ wg${WGID}.conf  | grep 'AllowedIps ' | cut -d= -f2)"
  >&2 echo user $2 already exists using ${IP}
  exit 1
fi

k=
if [ -f allKeys.txt ]
then
K=$(grep ^${2}: allKeys.txt | cut -d: -f2)
fi

if [ -z "$K" ]
then
 K=$(wg genkey);
 echo ${2}:$K >> allKeys.txt
fi
P=$(echo $K | wg pubkey)

cat << EOF

[Peer]
# user:$2
#PrivateKey = $K
PublicKey = $P
AllowedIps = ${CLIENT_IP}/32
EOF

if [ -t 1 ] ; then
>&2 echo add this key in wg${WGID}.conf by hand or with:
>&2 echo "$0" "$@" \>\> wg${WGID}.conf
else
>&2 echo -e "\e[31m$2\e[0m Key generated With IP: \e[32m${CLIENT_IP}\e[0m"
fi

>&2 echo
>&2 echo Now restart wireguard service to take effect
# >&2 echo "add this key in wg${WGID}.conf then"
>&2 echo systemctl restart wg-quick@wg${WGID}.service
