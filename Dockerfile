FROM alpine:3.14
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add --no-cache autoconf libxslt-dev libxslt libc-dev automake g++ gcc git libtool m4 make swig c-ares-dev c-ares
RUN apk add --no-cache wget jq pv bash python3 python3-dev libjpeg jpeg-dev py3-wheel unzip p7zip py3-pip aria2 xz neofetch  mediainfo ffmpeg c-ares-dev crypto++-dev curl curl-dev cvs file  freeimage freeimage-dev g++ gcc git  libc-dev libffi-dev libressl-dev  libressl3.3-libcrypto libsodium git libtool linux-headers perl pkgconf python3 python3-dev re2c tar libsodium-dev libuv-dev  make openssl  openssl-dev  pcre-dev  readline-dev  sqlite-dev  build-base cmake curl  zlib-dev
RUN apk add --no-cache \
        boost-system \
        boost-thread \
        ca-certificates \
        curl \
        dumb-init \
        libressl \
        qt5-qtbase
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev
RUN apk add --no-cache -t .build-deps \
        boost-dev \
        cmake \
        g++ \
        git \
        libressl-dev \
        make \
        qt5-qttools-dev \
        openssl-dev
ARG LIBTORRENT_VERSION=1.2.14
ARG QBITTORRENT_VERSION=4.3.8
ENV MEGA_SDK_VERSION="3.9.7"
RUN rm -rf /var/cache/apk/*

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt && rm -f requirements.txt

RUN set -x && \
    
    apk add --no-cache -t .build-deps \
        boost-dev \
        curl \
        g++ \
        make \
        openssl-dev \
        qt5-qtsvg-dev \
        qt5-qttools-dev \
    && \
    
    curl -L -o /tmp/qBittorrent-$QBITTORRENT_VERSION.tgz "https://github.com/qbittorrent/qBittorrent/archive/release-$QBITTORRENT_VERSION.tar.gz" && \
    tar -xzv -C /tmp -f /tmp/qBittorrent-$QBITTORRENT_VERSION.tgz && \
    cd /tmp/qBittorrent-release-$QBITTORRENT_VERSION && \
    
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure --disable-stacktrace && \
    make && \
    make install && \
    cd / && \
    apk del --purge .build-deps && \
    rm -rf /tmp/*

RUN git clone https://github.com/meganz/sdk.git --depth=1 -b v$MEGA_SDK_VERSION ~/home/sdk \
    && cd ~/home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && cd dist/ && pip3 install wheel && pip3 install --no-cache-dir megasdk-$MEGA_SDK_VERSION-*.whl 

RUN curl -L -o /tmp/libtorrent-$LIBTORRENT_VERSION.tar.gz "https://github.com/arvidn/libtorrent/archive/v$LIBTORRENT_VERSION.tar.gz" && \
    tar -xzv -C /tmp -f /tmp/libtorrent-$LIBTORRENT_VERSION.tar.gz && \
    cd /tmp/libtorrent-$LIBTORRENT_VERSION && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib && \
    make && \
    make install && \
    
    cd / && \
    apk del --purge .build-deps && \
    rm -rf /tmp/*



RUN apk del --purge g++ gcc libtool m4 make autoconf cmake automake
RUN qbittorrent-nox -v

