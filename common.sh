#!/bin/sh

>&2 echo -e "- using \e[31mwg${WGID}\e[0m on network \e[32m${IP_FIRST}/${MASK}\e[0m -"
>&2 echo 

## https://gist.github.com/jjarmoc/1299906
dec2ip() {
  # itoa
  # returns the dotted-decimal ascii form of an IP arg passed in integer format
  echo -n $(($((${1}/16777216))%256)).
  echo -n $(($((${1}/65536))%256)).
  echo -n $(($((${1}/256))%256)).
  echo $((${1}%256))
}

## https://stackoverflow.com/questions/10768160/ip-address-converter
ip2dec() {
    # itoa
    # Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
    local a b c d ip=$1
    IFS=. read -r a b c d <<< "$ip"
    echo $((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))
}

# get IP count - 1 in mask
# 32 => 1,  31 => 2
# 30 => 4,  29 => 8
# 28 => 16, 27 => 32 ...
maskSize() { echo $((2 ** (32 - $1) )); }

# translatre IP
# $1 ip source
# $2 offset
trIP() {
    DEC=$(ip2dec $IP_FIRST)
    DEC=$(($DEC+$2))
    echo $(dec2ip $DEC)
}
