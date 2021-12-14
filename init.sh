#!/bin/bash
. .env

# enable debug with:
# echo module wireguard +p > /sys/kernel/debug/dynamic_debug/control
K=$(wg genkey);
P=$(echo $K | wg pubkey)

cat << EOF
[Interface]
Address = ${IP1}.${IP2}.${IP3}.254/24
ListenPort = ${PORT}
PrivateKey = ${K}
# PublicKey = ${P}
# PostUp   = iptables -A FORWARD -i vmbr1 -o wg${WGID} -j ACCEPT; iptables -A FORWARD -i wg${WGID} -o vmbr1 -j ACCEPT
# PostDown = iptables -D FORWARD -i vmbr1 -o wg${WGID} -j ACCEPT; iptables -D FORWARD -i wg${WGID} -o vmbr1 -j ACCEPT
EOF

# export LOG_LEVEL=verbose

>&2 echo ./init.sh \> wg${WGID}.conf
