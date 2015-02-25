# This script deletes a local route

me=`basename $0`
function usage(){
  echo "Usage: $me CONTAINERNAME"
  echo "   CONTAINERNAME    The name of a running container for which to delete a network route"
  exit 1
}
if [ $# -lt 1 ]; then
  usage
fi

cname=$1
name="publicnetwork-$cname"
pubip=$(docker logs $name | grep "bound to" | awk '{print $3}');
if [[ $pubip ]]; then
  route del -host $pubip docker0
  echo "Route on docker0 for $pubip removed"
else
  echo "No network container found for $cname or no IP bound to network container."
fi
