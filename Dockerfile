FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN apt update -y && \                                                                           
    apt install tzdata -y ENV TZ="America/New_York" && \
    apt install aria2 p7zip-full -y && \
    apt install git  python3 python3-pip curl mediainfo ffmpeg wget mkvtoolnix -y && \                                                            
    pip3 install yt-dlp
    wget -q https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz
    7z x gclone_1.51.0-mod1.3.1_Linux_x86_64.gz > /dev/null
    chmod a+x ./gclone && mv ./gclone /usr/bin/
