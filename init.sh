#!/bin/bash
. .env
. common.sh

umask 077
# enable debug with:
# echo module wireguard +p > /sys/kernel/debug/dynamic_debug/control
K=$(wg genkey);
P=$(echo $K | wg pubkey)


OFFSET=$(($(maskSize ${MASK})-2))
SRV=$(trIP $IP_FIRST $OFFSET)

cat << EOF
[Interface]
Address = ${SRV}/${MASK}
ListenPort = ${PORT}
PrivateKey = ${K}
# PublicKey = ${P}
# PostUp   = iptables -A FORWARD -i vmbr1 -o wg${WGID} -j ACCEPT
# PostUp   = iptables -A FORWARD -i wg${WGID} -o vmbr1 -j ACCEPT
# PostDown = iptables -D FORWARD -i vmbr1 -o wg${WGID} -j ACCEPT
# PostDown = iptables -D FORWARD -i wg${WGID} -o vmbr1 -j ACCEPT
EOF

# export LOG_LEVEL=verbose

if [ -t 1 ] ; then
>&2 echo
>&2 echo ./init.sh \> wg${WGID}.conf
>&2 echo
>&2 echo Copy and paste the single line above to init your environement
else
>&2 echo Conf generated
fi
