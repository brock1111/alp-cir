FROM ubuntu:20.04

# install dependencies
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get -qq -y update && apt-get -qq -y upgrade && apt-get -qq install -y software-properties-common \
        && add-apt-repository ppa:rock-core/qt4 \
        && apt-get -qq install -y tzdata python3 python3-pip \
        unzip p7zip-full p7zip-rar aria2 wget curl \
        pv jq ffmpeg locales python3-lxml xz-utils neofetch \
        git g++ gcc autoconf automake \
        m4 libtool qt4-qmake make nzbget libqt4-dev libcurl4-openssl-dev \
        libcrypto++-dev libsqlite3-dev libc-ares-dev \
        libsodium-dev libnautilus-extension-dev \
        libssl-dev libfreeimage-dev swig apache2-utils


# Install all the required packages
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update
RUN curl -sL https://git.io/file-transfer | sh
RUN mv transfer /usr/bin
RUN chmod a+x /usr/bin/transfer
RUN git clone https://github.com/philipperemy/expressvpn-python evpn && \
    cd evpn && dpkg -i expressvpn_2.3.4-1_amd64.deb && pip install .
RUN add-apt-repository universe
RUN apt-get -qq update
RUN add-apt-repository multiverse
RUN for key in 03C3AD3A7F068E5D; do \
        gpg --recv-keys "$key" \
        && gpg --export "$key" | apt-key add - ; \
    done
RUN apt-get -qq update
RUN add-apt-repository restricted
RUN apt-get -qq update
RUN apt-get install -y apt-transport-https coreutils
RUN apt-get -qq install -y --no-install-recommends cdtool curl git gnupg2 unzip wget pv jq
RUN cd /usr/bin && wget https://easyclone.xd003.workers.dev/0:/lclone/lclone-v1.55.0-DEV-linux-amd64.zip && unzip lclone-v1.55.0-DEV-linux-amd64.zip && chmod a+x lclone && cd /usr/src/app
# add mkvtoolnix
RUN apt-get install -y mkvtoolnix
#RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
 #   wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
#RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
 #   sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

# install required packages
RUN apt-get update && apt-get install -y software-properties-common
    # this package is required to fetch "contents" via "TLS"7
    
    # install coreutils
RUN apt-get install -y coreutils aria2 jq pv gcc g++ \
    # install encoding tools
    mediainfo \
    # miscellaneous
    neofetch python3-dev git bash build-essential nodejs npm ruby \
    locales python-lxml qbittorrent-nox nginx gettext-base xz-utils \
    # install extraction tools
    p7zip-full p7zip-rar rar unrar zip unzip \
    # miscellaneous helpers
    megatools mediainfo && \
    # clean up the container "layer", after we are done
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
    tar xvf ffmpeg*.xz && \
    cd ffmpeg-*-static && \
    mv "${PWD}/ffmpeg" "${PWD}/ffprobe" /usr/local/bin/

ENV LANG C.UTF-8


# MEGA-CMD
RUN apt-get update \
    && apt-get -y install \
    --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    && update-ca-certificates \
    && curl  \
    https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/megacmd-xUbuntu_20.04_amd64.deb \
    --output /tmp/megacmd.deb \
    && apt install /tmp/megacmd.deb -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/megacmd.*


# we don't have an interactive xTerm
#ENV DEBIAN_FRONTEND noninteractive

# sets the TimeZone, to be used inside the container
ENV TZ Asia/Kolkata

# rclone ,gclone and fclone
RUN curl https://rclone.org/install.sh | bash && \
    aria2c https://git.io/gclone.sh && bash gclone.sh && \
    aria2c https://github.com/mawaya/rclone/releases/download/fclone-v0.4.1/fclone-v0.4.1-linux-amd64.zip && \
    unzip fclone-v0.4.1-linux-amd64.zip && mv fclone-v0.4.1-linux-amd64/fclone /usr/bin/ && chmod +x /usr/bin/fclone && rm -r fclone-v0.4.1-linux-amd64

#drive downloader
RUN curl -L https://github.com/jaskaranSM/drivedlgo/releases/download/1.5/drivedlgo_1.5_Linux_x86_64.gz -o drivedl.gz && \
    7z x drivedl.gz && mv drivedlgo /usr/bin/drivedl && chmod +x /usr/bin/drivedl && rm drivedl.gz

#ngrok
RUN aria2c https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip && mv ngrok /usr/bin/ && chmod +x /usr/bin/ngrok

#install rmega
RUN gem install rmega

# Copies config(if it exists)


# Install requirements and start the bot
# RUN npm install

#install requirements


RUN npm install zippydl -g
RUN npm install -g decrypt-dlc-cli
# setup workdir
RUN dpkg --add-architecture i386 && apt-get update && apt-get -y dist-upgrade
