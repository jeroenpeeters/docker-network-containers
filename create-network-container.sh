# This script creates a networking container 

me=`basename $0`
if [ $# -lt 2 ]; then
  echo "Usage: $me CONTAINERNAME IFDEV"
  echo "   CONTAINERNAME    The name of a running container for which to create a network container"
  echo "   IFDEV            The name of the network device on the host machine through which network traffic should be bridged"
  exit 1
fi

# The first argument is the name of the existing container for which
# we want to expose its ports on a public address
cname=$1

# The second argument is the name of the network device on the host that
# should be bridged into the networking container
ifdev=$2

# get the container's exposed ports
ports=$(docker ps | grep " $cname" | awk -F" {2,}" '{print $6}' | grep -o -G '\->[0-9]*' | grep -o -G '[0-9]*')

# create the script for running inside the networking container
mkdir -p /tmp/docker_networking/
# name of the network container
name="publicnetwork-$cname" 
# name of the script
script="$RANDOM$$$$$$.sh"
# create the script
# wait for eth1 to be created
echo "/opt/bin/pipework --wait -i eth1" >> /tmp/docker_networking/$script
# acquire ip from dhcp server
echo "dhclient -v eth1" >> /tmp/docker_networking/$script
# lookup the ip of the private_server in the docker network
echo "ip=\$(echo \$(cat /etc/hosts | grep private_server) | cut -d ' ' -f 1)" >> /tmp/docker_networking/$script
echo $ports | while read -r port ; do
  echo "iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination \$ip:$port" >> /tmp/docker_networking/$script
done
echo "iptables -t nat -A POSTROUTING -j MASQUERADE" >> /tmp/docker_networking/$script
echo "bash" >> /tmp/docker_networking/$script

# make it executable, writable
chmod a+wrx /tmp/docker_networking/$script
# start the network container executing the script
id=$(docker run --privileged --name $name -v /tmp/docker_networking:/scripts/ -dti --link $cname:private_server jeroenpeeters/public-networking:latest bash /scripts/$script)
echo "containerid=$id"

# create a new network device eth1 inside the networking container
# and bridge it to the host network device
sudo /opt/bin/pipework $ifdev $id 0/0

# wait for the public ip to be bound to the networking container
while [ 1 ]; do
  pubip=$(docker logs $name | grep "bound to" | awk '{print $3}');
  if [[ $pubip ]]; then
    echo "ip=$pubip"
    break;
  else
    echo "waiting for public ip to be bound"
    sleep 5
  fi
done

# container is running, remove the script
rm /tmp/docker_networking/$script
