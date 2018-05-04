FROM ubuntu
MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>
RUN apt-get update && apt-get -y install jp2a
ADD https://raw.githubusercontent.com/lordbasex/docker/master/docker-mario-run/docker-mario-run.jpg /tmp/docker-mario-run.jpg
ENV TERM xterm-256color
CMD jp2a /tmp/docker-mario-run.jpg
