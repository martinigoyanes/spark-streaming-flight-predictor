FROM apache/spark-py:3.3.1
ARG USERNAME
SHELL ["/bin/bash", "-c"]

USER root
RUN apt install -y curl unzip
# Create user 
RUN useradd -ms /bin/bash $USERNAME


COPY . /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

ENV SBT_VERSION 1.5.5
RUN curl -L -o sbt-$SBT_VERSION.zip https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.zip
RUN unzip sbt-$SBT_VERSION.zip -d sbt-$SBT_VERSION

ENV PATH="$PATH:/home/$USERNAME/.local/bin"

# Set up the virtual environment:
RUN pip3 install -U virtualenv
RUN virtualenv -p python3.9 /home/$USERNAME/env
RUN source /home/$USERNAME/env/bin/activate

RUN pip3 install -r ~/requirements.txt
USER root
ENTRYPOINT ["tail", "-f", "/dev/null"]
# ENTRYPOINT ["python3", "train_spark_mllib_model.py", "."]
# CMD ["/bin/bash"]

# docker build -f Dockerfile -t flight-predictor-frontend .
# docker run -p 5000:5000 -it --rm --name flight-predictor-frontend flight-predictor-frontend /bin/bash