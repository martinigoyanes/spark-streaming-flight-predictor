#!/bin/bash
# Start minikube with virtualbox virtualization
minikube start --vm-driver=virtualbox

# Start MongoDB node and load data into it
minikube kubectl -- apply -f 00-mongodb.yaml
./setup-mongodb.sh

# Start mongo express to easier visualization of data in MongoDB
minikube kubectl -- apply -f 01-mongo-express.yaml

# Start zookeeper for management of Kafka nodes
minikube kubectl -- apply -f 02-zookeeper.yaml

# Wait for zookeeper to be running before starting Kafka with specific topic
ZOOKEEPER_POD_UID=$(minikube kubectl -- get pod | grep mongodb | awk '{print $1}')
minikube kubectl -- wait --for=condition=Ready "pod/${ZOOKEEPER_POD_UID}"
minikube kubectl -- apply -f 03-kafka.yaml
