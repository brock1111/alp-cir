FROM ubuntu:20.04
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update -y && \
    apt install -y tzdata jq && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt install -y aria2 p7zip-full git python3 python3-pip curl mediainfo ffmpeg wget mkvtoolnix && \                                                            
    wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/bin/mpx && chmod a+rx /usr/bin/mpx
RUN wget -q https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz && \
    7z x gclone_1.51.0-mod1.3.1_Linux_x86_64.gz > /dev/null && \
    chmod a+x ./gclone && \
    mv ./gclone /usr/bin/ && \
    mv /usr/bin/mkvmerge /usr/bin/cmp
