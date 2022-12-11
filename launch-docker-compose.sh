#!/bin/bash
# Spawn docker-compose
cd docker-compose/ &&  docker-compose up --build --force-recreate && cd ..

# connect to URL
open http://localhost:5000/flights/delays/predict_kafka
