FROM alpine:3.18

RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        util-linux \
        openrc \
        rsyslog \
        mosquitto \
        sudo

VOLUME /sys/fs/cgroup

RUN rc-update add rsyslog default \
  && mkdir /run/openrc \
  && touch /run/openrc/softlevel

# Install tedge
RUN wget -O - thin-edge.io/install.sh | sh

COPY dist/tedge-openrc_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-openrc_*.apk

COPY ./images/check.sh /usr/bin/

ENTRYPOINT [ "/sbin/init" ]
