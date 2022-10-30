FROM python:3.7.15
ARG USERNAME
SHELL ["/bin/bash", "-c"]

# Create user 
RUN useradd -ms /bin/bash $USERNAME


COPY . /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
ENV PATH="$PATH:/home/$USERNAME/.local/bin"

# Set up the virtual environment:
RUN pip3 install -U virtualenv
RUN virtualenv -p python3.7 /home/$USERNAME/env
RUN source /home/$USERNAME/env/bin/activate

RUN pip3 install -r ~/requirements.txt
ENTRYPOINT ["python3", "predict_flask.py"]
# CMD ["/bin/bash"]

# docker build -f Dockerfile -t flight-predictor-frontend .
# docker run -p 5000:5000 -it --rm --name flight-predictor-frontend flight-predictor-frontend /bin/bash