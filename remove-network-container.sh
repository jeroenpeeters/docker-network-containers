me=`basename $0`
if [ $# -lt 1 ]; then
  echo "Usage: $me CONTAINERNAME"
  echo "   CONTAINERNAME    The name of a running container for which the public networking container should be removed"
  exit 1
fi

name=$1
if [[ $(docker ps | grep $name) ]]; then
  if [[ $(docker ps | grep publicnetwork-$name) ]]; then
    x=$(docker rm --link publicnetwork-$name/private_server)
    x=$(docker stop publicnetwork-$name)
  else
    echo "Container $name has no public networking container"
  fi
else
  echo "No container with name $name"
  exit 2
fi
