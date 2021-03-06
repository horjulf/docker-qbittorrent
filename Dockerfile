ARG OS_TAG=3.13

# Runtime
FROM sc4h/alpine-s6overlay:${OS_TAG}

ARG QBITTORRENT_VERSION="4.3.5"
ARG LIBTORRENT_VERSION="1.2.13"

LABEL maintainer="horjulf"

ENV \
  HOME="/config" \
  XDG_CONFIG_HOME="/config" \
  XDG_DATA_HOME="/config" \
  # 3 minutes for services to exit
  S6_SERVICES_GRACETIME=180000 \
  S6_KILL_GRACETIME=3000

# Install packages
RUN \
  echo "**** install packages ****" \
  && apk add --no-cache --upgrade \
    bind-tools \
    ca-certificates \
    curl \
    mediainfo \
    openssl \
    procps \
    tar \
    unrar \
    unzip \
    wget \
    zlib \
  && echo "**** install qbittorrent-nox ****" \
  && curl -sSf -L -o /usr/bin/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_v${LIBTORRENT_VERSION}/qbittorrent-nox-x86_64" \
  && chmod 755 /usr/bin/qbittorrent-nox \
  && echo "**** cleanup ****" \
  && rm -rf \
    /root/.cache \
    /tmp/*

# Add root files
COPY ["root/", "/"]

# Volumes
VOLUME ["/config", "/downloads"]

# Expose
EXPOSE 8080/tcp
