FROM alpine:3.18

ENV CRON_PATH /etc/crontabs

RUN mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

RUN apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata \
      python3 \
      py3-pip

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

# Create the virtual environment
RUN python3 -m venv /env

# Activate the virtual environment
ENV PATH="/env/bin:$PATH"

RUN python -m pip install --upgrade pip
RUN apk add --no-cache gcc python3-dev musl-dev linux-headers

RUN apk add texlive-full

#RUN pip install -r requirements.txt

#RUN npm install

ENV HOST 0.0.0.0
ENV PORT 8000
ENV CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
