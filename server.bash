#!/biin/bash
if [[ -f ${FILE} ]]
then 
        echo "the file ${FILE} exists. would you like to overwrite it? yes or no"
	  read answer
	  if [[ ${answer} == "no" || ${answer} == "n"  ]]
	  then
		    echo "exiting..."
		    exit 0
	  elif [[ ${answer} == "yes" ]] || ${answer} == "y" ]]
	  then
		    echo "updating config file"
	  else
		    echo "Invalid value"
		    exit 1
	fi
fi

p="$(wg genkey)"
echo "${p}" > /etc/wireguard/server_private.key

address="10.254.132.0/24"

ServerAddress="10.254.132.1/24"

lport="4282"

peerInfo="# ${address} 192.168.241.131:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

echo "${peerInfo}
[Interface]
Address=${ServerAddress}
PostUp=iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
PostDown=iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens33 -j MASQUERADE
ListenPort=${lport}
PrivateKey=${p}
" > /etc/wireguard/wg0.conf 
exit
