cname=$1
etcd_url=$2

myip=$(docker exec publicnetwork-$cname ifconfig eth1 | grep "inet addr:" | awk '{print $2}' | awk -F: '{print $2}')
curl -XPUT $etcd_url -d value={\"host\":\"$myip\"}
