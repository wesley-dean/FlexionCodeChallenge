FROM python:2.7-alpine

WORKDIR /app
RUN mkdir -p /app

# pull down the latest package lists
RUN apk update && apk add git

# add application code
RUN git clone https://github.com/wesley-dean/FlexionCodeChallenge.git /app

# install requirements
RUN pip install --requirement requirements.txt --upgrade

# run the executable
CMD /bin/bash /app/verify_temperature.bash
