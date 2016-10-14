#!/bin/bash

if [[ -z $1 ]]; then
    echo "Missing manager server"
    exit 1
fi

manager=$1

echo "Retrieving services from manager: ${manager}"
eval $(docker-machine env ${manager})
function joinl { local IFS="$1 " ; shift ; echo "$*" ; }
s=$(joinl ,  "${@:2}")
echo "Updating logger on: [${s}]"

for SERVICE in ""${@:2}""; do
  docker service update $SERVICE \
         --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201
done