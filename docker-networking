# This script creates a networking container 

# The first argument is the name of the existing container for which
# we want to expose its ports on a public address
cname=$1

# The second argument is the name of the network device on the host that
# should be bridged into the networking container
ifdev=$2

# get the container's exposed ports
ports=$(docker ps | grep $cname | awk -F" {2,}" '{print $6}')

# start the networking container
nname="publicnetwork-$1"
id=$(docker run --privileged --name $nname -di --link $cname:private_server public-networking:latest)
echo "containerid=$id"

# create a new network device eth1 inside the networking container
# and bridge it to the host network device
sudo /opt/bin/pipework $ifdev $id 0/0
