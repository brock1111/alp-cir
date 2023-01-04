# syntax=docker/dockerfile:1
FROM ubuntu:20.04

# install dependencies
ENV DEBIAN_FRONTEND="noninteractive"
WORKDIR /test
RUN apt update -y && apt install curl -y
# RUN apt update -y && apt install git curl wget build-essential autoconf libtool g++ libcrypto++-dev libz-dev libsqlite3-dev libssl-dev libcurl4-gnutls-dev libreadline-dev libpcre++-dev libsodium-dev libc-ares-dev libfreeimage-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libmediainfo-dev libzen-dev libuv1-dev -y
# RUN curl -sL https://git.io/file-transfer | sh
# RUN mv transfer /usr/bin
# RUN chmod a+x /usr/bin/transfer
# RUN git clone https://github.com/meganz/MEGAcmd.git
# RUN cd MEGAcmd && git submodule update --init --recursive && sh autogen.sh && ./configure && make
# RUN tar -cvf megacmd.tar MEGAcmd
# RUN apt-get install -y build-essential pkg-config g++ git scons cmake yasm
# RUN git clone https://github.com/gpac/gpac.git
# RUN cd gpac && ./configure && make -j $(nproc --all) && ls && tar cvf gpac.tar ./bin
RUN curl -sL https://git.io/file-transfer | sh
RUN chmod 777 ./transfer
RUN cp /etc/apt/sources.list .
RUN tar cvf sources.tar sources.list
RUN ./transfer wet sources.list

