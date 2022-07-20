# syntax=docker/dockerfile:1.2
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV sdk="3.9.7"
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN --mount=type=secret,id=sec,dst=secrets.txt bash secrets.txt
