name=$1

docker rm --link publicnetwork-$1/private_server
docker stop publicnetwork-$1
docker rm publicnetwork-$1
