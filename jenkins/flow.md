```
$ docker volume create --name jenkins-home

$ docker service create \
    --name jenkins \
    -p 8080:8080 \
    -p 50000:50000 \
    --mount type=volume,src=jenkins-home,dst=/var/jenkins_home \
    jenkins
3of5j4td4nynvx3xduo9q9io0

$ docker service ps jenkins
ID                         NAME       IMAGE    NODE     DESIRED STATE  CURRENT STATE             ERROR
5e9amn0tvxyzsn57wnc0753bp  jenkins.1  jenkins  worker1  Running        Preparing 10 seconds ago

$ docker service ps jenkins
ID                         NAME       IMAGE    NODE     DESIRED STATE  CURRENT STATE               ERROR
5e9amn0tvxyzsn57wnc0753bp  jenkins.1  jenkins  worker1  Running        Running about a minute ago
```

```
$ eval $(docker-machine env worker1)

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                 NAMES
d6eb4ff0f6e3        jenkins:latest      "/bin/tini -- /usr/lo"   3 minutes ago       Up 3 minutes        8080/tcp, 50000/tcp   jenkins.1.5e9amn0tvxyzsn57wnc0753bp
```


# ELK

[Codeship blog](https://blog.codeship.com/monitoring-docker-containers-with-elasticsearch-and-cadvisor/)

```
$ docker network create monitoring -d overlay

$ docker service create \
  --network=monitoring \
  --mount type=volume,target=/usr/share/elasticsearch/data \
  --constraint node.hostname==worker1 \
  --name elasticsearch \
  elasticsearch:2.4.0

$ docker service create \
  --network=monitoring \
  -e ELASTICSEARCH_URL="http://elasticsearch:9200" \
  -p 5601:5601 \
  --name kibana \
  kibana:4.6.0

$ docker service create \
  --network=monitoring \
  --mode global \
  --mount type=bind,source=/,target=/rootfs,readonly=true \
  --mount type=bind,source=/var/run,target=/var/run,readonly=false \
  --mount type=bind,source=/sys,target=/sys,readonly=true \
  --mount type=bind,source=/var/lib/docker/,target=/var/lib/docker,readonly=true \
  --name cadvisor \
  google/cadvisor:latest \
  -storage_driver=elasticsearch \
  -storage_driver_es_host="http://elasticsearch:9200"
```