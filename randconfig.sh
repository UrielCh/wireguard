#!/bin/sh

WGID=$(shuf -i 0-200 -n 1)
IP_FIRST=10.${WGID}.0.0
# default 1022 IP
MASK=22
PORT=$(shuf -i 1025-65000 -n 1)
# Get external IP address in a shell using openDns:
END_POINT=$(dig +short myip.opendns.com @resolver1.opendns.com):${PORT}
END_POINT=$(dig +short txt ch whoami.cloudflare @1.0.0.1):${PORT}
if [ "$END_POINT" = ":${PORT}" ]
then
 echo "failed to detect your public IP" >2
 echo "please complete END_POINT" >2
fi
# Get external IP address in a shell using Google:
#END_POINT=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com):${PORT}
# Get external IP address in a shell using Cloudflare:
#END_POINT=$(dig +short txt ch whoami.cloudflare @1.0.0.1):${PORT}
echo "# wireguard environement generated by $0"
echo '# Choose an Wireguard ID'
echo WGID=${WGID}
echo 
echo '# Choose a first IP, this IP must be the start of your IP Range matching your network mask'
echo IP_FIRST=${IP_FIRST}
echo 
echo '# Choose a mask, default is 22, allowing 1022 usable VPN IP'
echo '# Ex: 16 will allows 65534 usable VPN IP'
echo '# Ex: 22 will allows 1022 usable VPN IP'
echo '# Ex: 24 will allows 254 usable VPN IP'
echo MASK=22
echo 
echo '# Choose a random port number'
echo PORT=$PORT
echo 
echo '# Provide the endpoint used by client to connect'
echo END_POINT=${END_POINT}
echo 
echo '# PersistentKeepalive'
echo PersistentKeepalive=25
echo '# you can add extra route here like:'
echo '# EXTRA_ROUTE=", 192.168.10/24"'
echo 'EXTRA_ROUTE='
echo 
echo '# Optionaly, you push DNS server to clients'
echo '# CLIENT_DNS="1.1.1.1,1.0.0.1"'
echo 'CLIENT_DNS='
