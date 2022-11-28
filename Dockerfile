ARG OS_TAG=3.17

# Runtime
FROM sc4h/alpine-s6overlay:${OS_TAG}

ARG QBITTORRENT_VERSION
ARG LIBTORRENT_VERSION

LABEL \
  QBITTORRENT_VERSION=${QBITTORRENT_VERSION} \
  LIBTORRENT_VERSION=${LIBTORRENT_VERSION}

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
    unzip \
    wget \
    zlib \
  && echo "**** install qbittorrent-nox ****" \
  && curl -sSf -L -o /usr/bin/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_v${LIBTORRENT_VERSION}/x86_64-qbittorrent-nox" \
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
