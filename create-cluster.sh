# #!/bin/bash

# MASTER=manager1
# MANAGERS=( )
# NODES=(worker1 worker2)

# function joinl { local IFS="$1 " ; shift ; echo "$*" ; }

# echo "Create Swarm Master: ${MASTER}"
# docker-machine create --driver virtualbox $MASTER

# if [[ ${#MANAGERS[@]} -ne 0 ]]; then
#     SMANAGERS=$(joinl ,  ${MANAGERS[@]})
#     echo "Create Swarm nodes: [${SMANAGERS}]"
#     for MANAGER in ${MANAGERS[@]}; do
#         docker-machine create --driver virtualbox $MANAGER
#     done
# fi

# SNODES=$(joinl ,  ${NODES[@]})
# echo "Create Swarm nodes: [${SNODES}]"
# for NODE in ${NODES[@]}; do
#     docker-machine create --driver virtualbox $NODE
# done


# echo "Connecting to $MASTER"
# eval $(docker-machine env $MASTER)

# echo "Swarm initialization"
# echo "$MASTER will be a master"
# MASTER_IP=$(docker-machine ip $MASTER)
# docker swarm init --advertise-addr $MASTER_IP

echo "Retrieving worker join-token"
WORKER_TOKEN=$(docker swarm join-token -q worker)

echo "Joining [$SNODES] to $MASTER"
for NODE in ${NODES[@]}; do
    docker swarm join \
        --token $WORKER_TOKEN \
        $MASTER_IP:2377
done