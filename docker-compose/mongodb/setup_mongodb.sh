#!/bin/bash

# Import our enriched airline data as the 'airlines' collection
mongoimport --host mongo --db flight_predictor --collection origin_dest_distances --file origin_dest_distances.jsonl
mongo --host mongo flight_predictor --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})'

# Create collection for responses from Spark
mongo --host mongo flight_predictor --eval 'db.createCollection("flight_delay_classification_response")'

