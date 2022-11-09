# spark-streaming-flight-predictor
Real time flight delay predictor using Kafka, Zookeeper, Spark Streaming, MongoDB and HDFS

# How to Run:
## Google Kubernetes Engine (Kubernetes cluster with Public IP)
1. Create a project in Google Cloud and open the Google Cloud Shell ([https://cloud.google.com/kubernetes-engine/docs/deploy-app-cluster](https://cloud.google.com/kubernetes-engine/docs/deploy-app-cluster))
2. Set project in Cloud Shell:
```
gcloud config set project PROJECT_ID
```
3. Create GKE cluster with Autopilot for simplicity:
```
gcloud container clusters create-auto flight-delay-predictor-cluster --region=europe-west1	
```
4. Get credentials for the cluster:
```
gcloud container clusters get-credentials flight-delay-predictor-cluster --region europe-west1	
```
5. Apply kubernetes configuration:
```
git clone https://github.com/martinigoyanes/spark-streaming-flight-predictor.git src
cd src && /bin/bash create-gke-cluster.sh
```
6. Get External IP of the service ``webapp-service`` and go to [EXTERNAL_IP:5000/flights/delays/predict_kafka](flights/delays/predict_kafka)
#### Try my working version at [http://34.79.120.227:5000/flights/delays/predict_kafka](http://34.79.120.227:5000/flights/delays/predict_kafka) and click on Submit
## Docker Compose
Launch with:
```
/bin/bash launch-docker-compose.sh
```
If script does not open browser when docker-compose is finished, then go to: [http://localhost:5000/flights/delays/predict_kafka](http://localhost:5000/flights/delays/predict_kafka) and click on Submit
To clean and remove the services:
```
cd docker-compose/ && docker-compose down && cd ..
```
## Minikube (Kubernetes on your machine/one node)
Launch with:
```
/bin/bash create-minikube-cluster.sh
```
If script does not open browser when docker-compose is finished, then do
```
minikube service webapp-service
```
and go to [WEBAPP_SERVICE-EXTERNAL_IP:30000/flights/delays/predict_kafka](/flights/delays/predict_kafka) click on Submit

## Front End Architecture

This diagram shows how the front end architecture works in our flight delay prediction application. The user fills out a form with some basic information in a form on a web page, which is submitted to the server. The server fills out some neccesary fields derived from those in the form like "day of year" and emits a Kafka message containing a prediction request. Spark Streaming is listening on a Kafka queue for these requests, and makes the prediction, storing the result in MongoDB. Meanwhile, the client has received a UUID in the form's response, and has been polling another endpoint every second. Once the data is available in Mongo, the client's next request picks it up. Finally, the client displays the result of the prediction to the user! 

This setup is extremely fun to setup, operate and watch. Check out chapters 7 and 8 for more information!

![Front End Architecture](images/front_end_realtime_architecture.png)

## Back End Architecture

The back end architecture diagram shows how we train a classifier model using historical data (all flights from 2015) on disk (HDFS or Amazon S3, etc.) to predict flight delays in batch in Spark. We save the model to disk when it is ready. Next, we launch Zookeeper and a Kafka queue. We use Spark Streaming to load the classifier model, and then listen for prediction requests in a Kafka queue. When a prediction request arrives, Spark Streaming makes the prediction, storing the result in MongoDB where the web application can pick it up.

This architecture is extremely powerful, and it is a huge benefit that we get to use the same code in batch and in realtime with PySpark Streaming.

![Backend Architecture](images/back_end_realtime_architecture.png)

# Screenshots

Below are some examples of parts of the application we build in this book and in this repo. Check out the book for more!

## Airline Entity Page

Each airline gets its own entity page, complete with a summary of its fleet and a description pulled from Wikipedia.

![Airline Page](images/airline_page_enriched_wikipedia.png)

## Airplane Fleet Page

We demonstrate summarizing an entity with an airplane fleet page which describes the entire fleet.

![Airplane Fleet Page](images/airplanes_page_chart_v1_v2.png)

## Flight Delay Prediction UI

We create an entire realtime predictive system with a web front-end to submit prediction requests.

![Predicting Flight Delays UI](images/predicting_flight_kafka_waiting.png)
