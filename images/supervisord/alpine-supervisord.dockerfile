FROM alpine:3.18
# ARG TARGETARCH
# ARG TEDGE_VERSION=0.11.0

# Notes: ca-certificates is required for the initial connection with c8y, otherwise the c8y cert is not trusted
# to test out the connection. But this is only needed for the initial connection, so it seems unnecessary
RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        supervisor \
        mosquitto

RUN wget -O - thin-edge.io/install.sh | sh -s

COPY images/supervisord/supervisord.conf /etc/
COPY dist/tedge-supervisord_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-supervisord_*.apk

COPY ./images/setup.sh /usr/bin/

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
