# Setup machines

```
$ docker-machine create --driver virtualbox manager1
$ docker-machine create --driver virtualbox worker1
$ docker-machine create --driver virtualbox worker2
```

```
$ docker-machine ls
NAME       ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
manager1   -        virtualbox   Running   tcp://192.168.99.100:2376           v1.12.2
worker1    -        virtualbox   Running   tcp://192.168.99.101:2376           v1.12.2
worker2    -        virtualbox   Running   tcp://192.168.99.102:2376           v1.12.2
```

# Create a swarm

## Add manager

```
$ eval $(docker-machine env manager1)
```

```
$ docker swarm init --advertise-addr 192.168.99.100
Swarm initialized: current node (3zu83wmdhyzlt1ruymfdjho7e) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-1ds68wuithjvxfzp5czyud06o24mkz5y07sf62mfpz266glxq1-9ddlhwsxecxmlaa9kvhnv04zu \
    192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

```
$ docker info
...
Swarm: active
 NodeID: 3zu83wmdhyzlt1ruymfdjho7e
 Is Manager: true
 ClusterID: 6r9mduwxcgzcjtzqq6demnl3n
 Managers: 1
 Nodes: 1
 Orchestration:
  Task History Retention Limit: 5
 Raft:
  Snapshot Interval: 10000
  Heartbeat Tick: 1
  Election Tick: 3
 Dispatcher:
  Heartbeat Period: 5 seconds
 CA Configuration:
  Expiry Duration: 3 months
 Node Address: 192.168.99.100
...
```

```
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
3zu83wmdhyzlt1ruymfdjho7e *  manager1  Ready   Active        Leader
```

## Add workers

```
$ eval $(docker-machine env manager1)
$ docker swarm join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-1ds68wuithjvxfzp5czyud06o24mkz5y07sf62mfpz266glxq1-9ddlhwsxecxmlaa9kvhnv04zu \
    192.168.99.100:2377
```

```
$ eval $(docker-machine env worker1)
$ docker swarm join \
    --token SWMTKN-1-1ds68wuithjvxfzp5czyud06o24mkz5y07sf62mfpz266glxq1-9ddlhwsxecxmlaa9kvhnv04zu \
    192.168.99.100:2377
This node joined a swarm as a worker.
```

```
$ eval $(docker-machine env worker2)
$ docker swarm join \
    --token SWMTKN-1-1ds68wuithjvxfzp5czyud06o24mkz5y07sf62mfpz266glxq1-9ddlhwsxecxmlaa9kvhnv04zu \
    192.168.99.100:2377
This node joined a swarm as a worker.
```

```
$ eval $(docker-machine env manager1)
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
34pu7iivs27m9unb1uq394m7x    worker2   Ready   Active
3zu83wmdhyzlt1ruymfdjho7e *  manager1  Ready   Active        Leader
9scap2ld35nacnr0veuu7fk9b    worker1   Ready   Active
```

# Create service

```
$ eval $(docker-machine env manager1)
```

```
$ docker service create --replicas=1 --name hello-world alpine ping www.docker.com
96q4vow2swg4vkm66jpc5niy9
```

```
$ docker service ls
ID            NAME         REPLICAS  IMAGE   COMMAND
96q4vow2swg4  hello-world  1/1       alpine  ping www.docker.com
```

# Inspect service

```
$ eval $(docker-machine env manager1)
```

```
$ docker service ls
ID            NAME         REPLICAS  IMAGE   COMMAND
96q4vow2swg4  hello-world  1/1       alpine  ping www.docker.com
```

```
$ docker service inspect --pretty 96q4vow2swg4
ID:		96q4vow2swg4vkm66jpc5niy9
Name:		hello-world
Mode:		Replicated
 Replicas:	1
Placement:
UpdateConfig:
 Parallelism:	1
 On failure:	pause
ContainerSpec:
 Image:		alpine
 Args:		ping www.docker.com
Resources:
```

```
$ docker service inspect 96q4vow2swg4
```

```json
[
    {
        "ID": "96q4vow2swg4vkm66jpc5niy9",
        "Version": {
            "Index": 22
        },
        "CreatedAt": "2016-10-13T09:52:27.391790287Z",
        "UpdatedAt": "2016-10-13T09:52:27.391790287Z",
        "Spec": {
            "Name": "hello-world",
            "TaskTemplate": {
                "ContainerSpec": {
                    "Image": "alpine",
                    "Args": [
                        "ping",
                        "www.docker.com"
                    ]
                },
                "Resources": {
                    "Limits": {},
                    "Reservations": {}
                },
                "RestartPolicy": {
                    "Condition": "any",
                    "MaxAttempts": 0
                },
                "Placement": {}
            },
            "Mode": {
                "Replicated": {
                    "Replicas": 1
                }
            },
            "UpdateConfig": {
                "Parallelism": 1,
                "FailureAction": "pause"
            },
            "EndpointSpec": {
                "Mode": "vip"
            }
        },
        "Endpoint": {
            "Spec": {}
        },
        "UpdateStatus": {
            "StartedAt": "0001-01-01T00:00:00Z",
            "CompletedAt": "0001-01-01T00:00:00Z"
        }
    }
]
```

```
$ docker service ps hello-world
ID                         NAME           IMAGE   NODE      DESIRED STATE  CURRENT STATE          ERROR
0lbtujlng2m1pptka8cyfsojt  hello-world.1  alpine  manager1  Running        Running 5 minutes ago
```

```
$ docker service scale hello-world=5
hello-world scaled to 5
```

```
$ docker service ps hello-world
ID                         NAME           IMAGE   NODE      DESIRED STATE  CURRENT STATE           ERROR
0lbtujlng2m1pptka8cyfsojt  hello-world.1  alpine  manager1  Running        Running 3 hours ago
7ocw0e6rcmfn0i1d6ok07cfxt  hello-world.2  alpine  worker2   Running        Running 35 seconds ago
c0czgflsq8pllbocehst3q4xq  hello-world.3  alpine  worker1   Running        Running 43 seconds ago
5yhoqsiqdlyng6u66rk0m1m16  hello-world.4  alpine  worker1   Running        Running 43 seconds ago
1eb51211qe9088euk0pr7kw4s  hello-world.5  alpine  manager1  Running        Running 45 seconds ago
```

```
$ docker service rm hello-world
hello-world
```

```
$ docker service ps hello-world
Error: No such service: hello-world
```

# Rolling Update

```
$ eval $(docker-machine env manager1)
```

```
$ docker service create \
  --replicas 3 \
  --name redis \
  --update-delay 10s \
  redis:3.0.6
aas7lzhb1xj2g5eax9qaeuawj
```

```
$ docker service ls
ID            NAME   REPLICAS  IMAGE        COMMAND
aas7lzhb1xj2  redis  3/3       redis:3.0.6
```

```
$ docker service inspect --pretty redis
ID:		aas7lzhb1xj2g5eax9qaeuawj
Name:		redis
Mode:		Replicated
 Replicas:	3
Placement:
UpdateConfig:
 Parallelism:	1
 Delay:		10s
 On failure:	pause
ContainerSpec:
 Image:		redis:3.0.6
Resources:
```

```
$ docker service update --image redis:3.0.7 redis
redis
```

```
$ docker service inspect --pretty redis
ID:		aas7lzhb1xj2g5eax9qaeuawj
Name:		redis
Mode:		Replicated
 Replicas:	3
Update status:
 State:		updating
 Started:	2 seconds ago
 Message:	update in progress
Placement:
UpdateConfig:
 Parallelism:	1
 Delay:		10s
 On failure:	pause
ContainerSpec:
 Image:		redis:3.0.7
Resources:
```

```
$ docker service ps redis
ID                         NAME         IMAGE        NODE      DESIRED STATE  CURRENT STATE            ERROR
d80hm1std5wyn73vocuv2q96c  redis.1      redis:3.0.7  manager1  Running        Running 27 seconds ago
3g8j0yhzcq5a7mlajq0giob78   \_ redis.1  redis:3.0.6  worker1   Shutdown       Shutdown 28 seconds ago
9ubu5kalekf9wmhh30jq1j2go  redis.2      redis:3.0.6  worker2   Running        Running 2 seconds ago
ef9wgbvuiqla2b0lyd12qquqt  redis.3      redis:3.0.7  worker1   Running        Running 14 seconds ago
8c5gx9mynks54n1qzgqgb96dd   \_ redis.3  redis:3.0.6  manager1  Shutdown       Shutdown 15 seconds ago
```

# Drain node

```
$ eval $(docker-machine env manager1)
```

```
$ docker node update --availability drain worker1
worker1
```

```
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
34pu7iivs27m9unb1uq394m7x    worker2   Ready   Active
3zu83wmdhyzlt1ruymfdjho7e *  manager1  Ready   Active        Leader
9scap2ld35nacnr0veuu7fk9b    worker1   Ready   Drain
```

```
$ docker service ps redis
ID                         NAME         IMAGE        NODE      DESIRED STATE  CURRENT STATE                ERROR
d80hm1std5wyn73vocuv2q96c  redis.1      redis:3.0.7  manager1  Running        Running about a minute ago
3g8j0yhzcq5a7mlajq0giob78   \_ redis.1  redis:3.0.6  worker1   Shutdown       Shutdown about a minute ago
2lz411vw4l8zu6pbscpcvx4e7  redis.2      redis:3.0.7  worker2   Running        Running 4 seconds ago
55sqmeyzmvwkchu03ftid4ecs   \_ redis.2  redis:3.0.7  worker1   Shutdown       Shutdown 5 seconds ago
9ubu5kalekf9wmhh30jq1j2go   \_ redis.2  redis:3.0.6  worker2   Shutdown       Shutdown about a minute ago
7q3sgrxf9gdsm8vgwidmbjtse  redis.3      redis:3.0.7  worker2   Running        Running 4 seconds ago
ef9wgbvuiqla2b0lyd12qquqt   \_ redis.3  redis:3.0.7  worker1   Shutdown       Shutdown 5 seconds ago
8c5gx9mynks54n1qzgqgb96dd   \_ redis.3  redis:3.0.6  manager1  Shutdown       Shutdown about a minute ago
```

```
$ docker node update --availability=active worker1
worker1
```

```
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
34pu7iivs27m9unb1uq394m7x    worker2   Ready   Active
3zu83wmdhyzlt1ruymfdjho7e *  manager1  Ready   Active        Leader
9scap2ld35nacnr0veuu7fk9b    worker1   Ready   Active
```