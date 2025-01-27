# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM alpine:3.13.5

ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata \
      python3 \
      py3-pyzmq \
      py3-pip \
      g++

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   python3 -m pip --no-cache-dir install wheel ipython ipykernel papermill
RUN   ipython kernel install --name "python3" --user
RUN   npm install

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
