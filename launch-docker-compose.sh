#!/bin/bash
# Spawn docker-compose
cd docker-compose/ &&  docker-compose up --build --force-recreate && cd ..

# Wait 10min until docker compose is up and connect to URL
sleep 600
open http://localhost:5000/flights/delays/predict_kafka
