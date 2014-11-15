# This script installs the iptables routes into the Docker networking container

# wait for eth1 to come up
/opt/bin/pipework --wait -i eth1
# get ip from dhcp
dhclient -v eth1

# get the ip of the private server
ip=$(echo $(cat /etc/hosts | grep server) | cut -d ' ' -f 1)

# install routing rules
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $ip:80
iptables -t nat -A POSTROUTING -j MASQUERADE

#prevent docker from exiting
bash
