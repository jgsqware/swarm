# Images

```
docker pull jenkinsci/slave
docker pull jenkinsci/ssh-slave
docker pull evarga/jenkins-slave
docker pull tianon/jenkins-slave

docker pull gitlab/gitlab-ce

docker pull elasticsearch:2.4.0
docker pull kibana:4.6.0
docker pull google/cadvisor:latest

docker pull iflowfor8hours/jenkins2-pipeline-demo
```

# Local saving
```
docker save jenkinsci/slave > slave.tar &&
docker save jenkinsci/ssh-slave > ssh-slave.tar &&
docker save evarga/jenkins-slave > evarga-jenkins-slave.tar &&
docker save tianon/jenkins-slave > tianon-jenkins-slave.tar &&
docker save gitlab/gitlab-ce > gitlab-ce.tar && 
docker save elasticsearch:2.4.0 > elasticsearch.tar && 
docker save kibana:4.6.0 > kibana.tar && 
docker save google/cadvisor:latest > cadvisor.tar
```

# Cluster loading

In folde rwhere image are saved: 

```
docker save jenkinsci/slave > slave.tar &&
docker save jenkinsci/ssh-slave > ssh-slave.tar &&
docker save evarga/jenkins-slave > evarga-jenkins-slave.tar &&
docker save tianon/jenkins-slave > tianon-jenkins-slave.tar &&
docker save gitlab/gitlab-ce > gitlab-ce.tar && 
docker save elasticsearch:2.4.0 > elasticsearch.tar && 
docker save kibana:4.6.0 > kibana.tar && 
docker save google/cadvisor:latest > cadvisor.tar
```
