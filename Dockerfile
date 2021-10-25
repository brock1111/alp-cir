FROM alpine:3.14
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add autoconf automake g++ gcc git libtool m4 make swig c-ares-dev c-ares
RUN apk add autoconf automake wget jq pv python3 unzip p7zip py3-pip aria2 xz neofetch  mediainfo c-ares-dev crypto++-dev curl curl-dev cvs file  freeimage freeimage-dev g++ gcc git  libc-dev libffi-dev libressl-dev  libressl3.3-libcrypto libsodium libsodium-dev libuv-dev  make openssl  openssl-dev  pcre-dev  readline-dev  sqlite-dev  zlib-dev
RUN apk add autoconf automake build-base cmake curl git libtool linux-headers perl pkgconf python3 python3-dev re2c tar
RUN apk add --no-cache \
        boost-system \
        boost-thread \
        ca-certificates \
        curl \
        dumb-init \
        libressl \
        qt5-qtbase
        
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

RUN curl -L -o /tmp/libtorrent-$LIBTORRENT_VERSION.tar.gz "https://github.com/arvidn/libtorrent/archive/v$LIBTORRENT_VERSION.tar.gz" && \
    tar -xzv -C /tmp -f /tmp/libtorrent-$LIBTORRENT_VERSION.tar.gz && \
    cd /tmp/libtorrent-$LIBTORRENT_VERSION && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib && \
    make && \
    make install && \
    # Clean-up
    cd / && \
    apk del --purge .build-deps && \
    rm -rf /tmp/*

RUN set -x && \
    # Install build dependencies
    apk add --no-cache -t .build-deps \
        boost-dev \
        curl \
        g++ \
        make \
        openssl-dev \
        qt5-qttools-dev \
    && \
    # Build qBittorrent from source code
    curl -L -o /tmp/qBittorrent-$QBITTORRENT_VERSION.tgz "https://github.com/qbittorrent/qBittorrent/archive/release-$QBITTORRENT_VERSION.tar.gz" && \
    tar -xzv -C /tmp -f /tmp/qBittorrent-$QBITTORRENT_VERSION.tgz && \
    cd /tmp/qBittorrent-release-$QBITTORRENT_VERSION && \
    # Compile
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure --disable-gui --disable-stacktrace && \
    make && \
    make install


RUN qbittorrent-nox -v
