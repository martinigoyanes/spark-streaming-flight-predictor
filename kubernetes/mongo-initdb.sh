#!/bin/bash

curl -Lko /origin_dest_distances.jsonl http://s3.amazonaws.com/agile_data_science/origin_dest_distances.jsonl

# Import our enriched airline data as the 'airlines' collection
mongoimport -db flight_predictor --collection origin_dest_distances --file origin_dest_distances.jsonl
mongo flight_predictor --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})'

# Create collection for responses from Spark
mongo flight_predictor --eval 'db.createCollection("flight_delay_classification_response")'

