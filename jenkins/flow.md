```
$ docker volume create --name jenkins-home

$ docker service create \
    --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201 \
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

