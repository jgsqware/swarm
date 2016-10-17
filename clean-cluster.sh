#!/bin/bash

echo "Removing machines: [manager1, worker1, worker2]"
docker-machine rm -f manager1
docker-machine rm -f worker1
docker-machine rm -f worker2
