#!/bin/bash

if [[ -z $1 ]]; then
    echo "Missing manager server"
    exit 1
fi

manager=$1

echo "Retrieving nodes from manager: ${manager}"
eval $(docker-machine env ${manager})
nodes=($(docker node ls | sed 's/\*//' | awk '{print $2}'))
unset nodes[0]

function joinl { local IFS="$1 " ; shift ; echo "$*" ; }
s=$(joinl ,  ${nodes[@]})
echo "Loading images on: [${s}]"

images=($(ls -d *.tar))

for node in "${nodes[@]}" 
do 
    eval $(docker-machine env ${node})
    echo "Running on ${node}"

    for image in "${images[@]}"
    do
        echo "Loading ${image}"
        docker load < ${image}
    done
done
