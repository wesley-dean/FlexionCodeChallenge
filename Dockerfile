FROM python:2.7-alpine

ENV directory /app
ENV port 5000

RUN mkdir -p $directory

WORKDIR $directory

# pull down the latest package lists
RUN apk update && apk add git bash

# add application code
RUN git clone https://github.com/wesley-dean/FlexionCodeChallenge.git $directory

# install requirements
RUN pip install --requirement requirements.txt --upgrade

# run the executable
CMD port=$port /app/verify_temperature.bash
