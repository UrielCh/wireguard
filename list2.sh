#!/bin/bash
# ./list2.sh  | less -r
. .env
. common.sh

CONF="$(cat  wg${WGID}.conf)"

FORMAT="\e[32m%3d\e[0m %-14s  (\e[35m%s\e[0m)\n"
if [ $MASK -lt 23 ]
then
 FORMAT="\e[32m%4d\e[0m %-14s  (\e[35m%s\e[0m)\n"
fi

if [ $MASK -lt 20 ]
then
 FORMAT="\e[32m%5d\e[0m %-14s  (\e[35m%s\e[0m)\n"
fi

ACCOUNTS=()
for USR in $(echo "$CONF" | grep user: | cut -d: -f2)
do
 # echo test $USR
 IP=$(echo "$CONF" | grep -A4  \ user:${USR}$ | grep AllowedIps | grep -E -o '[0-9]+\.[0-9.]+')
 IP_ID=$(getIPOffset ${IP_FIRST} ${IP})
 # echo -ne "${USR}(\e[32m${IP_ID}\e[0m), "
 # echo -e "\e[32m${IP_ID}\e[0m ${USR}"
 # printf "${FORMAT}" $IP_ID $USR
 ACCOUNTS+=( "${IP_ID},${USR},${IP}" )
done

IFS=$'\n' sorted=($(sort -n <<<"${ACCOUNTS[*]}"))
# IFS=$'\n' sorted=${ACCOUNTS[*]}
unset IFS

for LINE in ${sorted[@]}
do
  IFS=',' read -r id name ip <<< "$LINE"
  unset IFS
  # echo $LINE
  printf  "${FORMAT}" $id  $name  $ip
done

echo
