#!/bin/bash

# Import our enriched airline data as the 'airlines' collection
mongoimport --host mongodb --db flight-predictor --collection origin_dest_distances --file origin_dest_distances.jsonl
mongo --host mongodb flight-predictor --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})'
