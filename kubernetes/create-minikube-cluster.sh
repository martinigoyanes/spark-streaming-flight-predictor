#!/bin/bash
# Start minikube with virtualbox virtualization
minikube start --vm-driver=virtualbox

# Start MongoDB node and load data into it
minikube kubectl -- apply -f 00-mongodb.yaml

sleep 20
MONGODB_POD_UID=$(minikube kubectl -- get pod | grep mongodb | awk '{print $1}')
minikube kubectl -- wait --for=condition=Ready "pod/${MONGODB_POD_UID}"
minikube kubectl -- exec -it "pod/${MONGODB_POD_UID}" -- /bin/bash -c "
apt-get update &&
apt-get install -y curl &&
curl -Lko /origin_dest_distances.jsonl http://s3.amazonaws.com/agile_data_science/origin_dest_distances.jsonl &&
mongoimport --authenticationDatabase=admin --username username --password password --db flight_predictor --collection origin_dest_distances --file origin_dest_distances.jsonl &&
mongo flight_predictor --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})' &&
mongo --authenticationDatabase=admin --username username --password password flight_predictor --eval 'db.createCollection(\"flight_delay_classification_response\")'
"

# Start mongo express to easier visualization of data in MongoDB
minikube kubectl -- apply -f 01-mongo-express.yaml

# Start zookeeper for management of Kafka nodes
minikube kubectl -- apply -f 02-zookeeper.yaml

# Wait for zookeeper to be running before starting Kafka with specific topic
ZOOKEEPER_POD_UID=$(minikube kubectl -- get pod | grep zookeeper | awk '{print $1}')
minikube kubectl -- wait --for=condition=Ready "pod/${ZOOKEEPER_POD_UID}"
minikube kubectl -- apply -f 03-kafka.yaml
