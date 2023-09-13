#!/bin/bash

echo -n "What is the peer's name? "
read the_client

pFile="${the_client}-wg0.conf"

if [[ -f "${pFile}" ]]
then 
       	echo "The file ${pFile} already exists."
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n"  ]]
	then
		echo "Exiting..."
		exit 0
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the wireguard configuration file..."
	else
		echo "Invalid value"
		exit 1
	fi
fi

p="$(wg genkey)"

clientPub="$(echo ${p} | wg pubkey)"

pre="$(wg genpsk)"

end="$(head -1 wg0.conf | awk ' { print $3 } ')"

pub="$(head -1 wg0.conf | awk ' { print $4 } ')"

dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

lport="$(shuf -n1 -i 40000-50000)"

routes="$(head -1 wg0.conf | awk ' { print $8 } ')"

echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}
[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pFile}
echo "
# ${the_client} begin
[Peer]
PublicKey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.100/32 
# ${the_client} end
" | tee -a wg0.conf
