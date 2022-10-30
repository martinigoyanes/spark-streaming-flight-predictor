FROM apache/spark-py:3.3.1
SHELL ["/bin/bash", "-c"]

USER root
RUN apt install -y curl unzip

COPY . /root

ENV SBT_VERSION 1.5.5
RUN curl -L -o sbt-$SBT_VERSION.zip https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.zip
RUN unzip sbt-$SBT_VERSION.zip -d /opt/sbt-$SBT_VERSION

# Set up the virtual environment:
RUN pip3 install virtualenv
RUN virtualenv -p python3.9 /root/env
RUN source /root/env/bin/activate

# Build ML models
RUN pip3 install -r /root/requirements.txt
RUN python3 /root/train_spark_mllib_model.py /root

# Build JAR for spark-submit
RUN cd /root/flight_prediction && /opt/sbt-$SBT_VERSION/sbt/bin/sbt package
# Launch spark-submit job
# RUN cd /root/flight_prediction && /opt/spark/bin/spark-submit --class MakePrediction --master local[*] target/scala-2.12/flight_prediction_2.12-0.1.jar
ENTRYPOINT ["cd /root/flight_prediction && /opt/spark/bin/spark-submit --class MakePrediction --master local[*] target/scala-2.12/flight_prediction_2.12-0.1.jar"]

# ENTRYPOINT ["tail", "-f", "/dev/null"]
# CMD ["/bin/bash"]

# docker build -f Dockerfile -t flight-predictor-frontend .
# docker run -p 5000:5000 -it --rm --name flight-predictor-frontend flight-predictor-frontend /bin/bash