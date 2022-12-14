FROM bitnami/spark:3.1.2
SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get update
RUN apt install -y curl unzip

COPY . /root

ENV SBT_VERSION 1.5.5
RUN curl -L -o sbt-$SBT_VERSION.zip https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.zip
RUN unzip sbt-$SBT_VERSION.zip -d /opt/sbt-$SBT_VERSION

# Set up the virtual environment:
# RUN pip3 install virtualenv
# RUN virtualenv -p python3.9 /root/env
# RUN source /root/env/bin/activate

# Download data to train models
RUN mkdir /root/data && curl -Lko /root/data/simple_flight_delay_features.jsonl.bz2 http://s3.amazonaws.com/agile_data_science/simple_flight_delay_features.jsonl.bz2

# Build ML models
RUN pip3 install -r /root/requirements.txt
RUN python3 /root/train_spark_mllib_model.py /root

# Build JAR for spark-submit
RUN cd /root/flight_prediction && /opt/sbt-$SBT_VERSION/sbt/bin/sbt package

# Launch spark-submit job
ENTRYPOINT /bin/bash -c "cd /root/flight_prediction && /opt/bitnami/spark/bin/spark-submit --class MakePrediction --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.2,org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2 --master local[*] target/scala-2.12/flight_prediction_2.12-0.1.jar"


