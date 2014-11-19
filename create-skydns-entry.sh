
cname=$1
etcd_url=$2

myip=$(docker logs publicnetwork-$cname | grep "bound to" | awk '{print $3}');
curl -XPUT $etcd_url -d value='{"host":"$myip"}'
