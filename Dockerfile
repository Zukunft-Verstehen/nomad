FROM alpine:3.12

LABEL maintainer="Tom Schamberger <tom@zukunft-verstehen.com>"

ENV RELEASE=0.12.5
ENV GLIBC_VERSION=2.25-r0

RUN addgroup nomad && \
    adduser -S -G nomad nomad

RUN set -x && \
    apk --update add --no-cache --virtual .deps curl unzip && \
    curl -L -o /tmp/glibc-${GLIBC_VERSION}.apk "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm -rf /tmp/glibc-${GLIBC_VERSION}.apk /var/cache/apk/* && \
    curl -L -o /usr/local/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64" && \
    chmod +x /usr/local/bin/dumb-init && \
    curl -L -o /tmp/nomad_${RELEASE}_linux_amd64.zip "https://releases.hashicorp.com/nomad/${RELEASE}/nomad_${RELEASE}_linux_amd64.zip" && \
    unzip -d /usr/local/bin /tmp/nomad_${RELEASE}_linux_amd64.zip && \
    rm /tmp/* && \
    chmod a+x /usr/local/bin/nomad && \
    apk del .deps && \
    nomad version

RUN set -x && \
    apk --update add --no-cache ca-certificates openssl && \
    update-ca-certificates

RUN mkdir -p /opt/nomad && \
    mkdir -p /etc/nomad.d && \
    chown -R nomad:nomad /opt/nomad && \
    chown -R nomad:nomad /etc/nomad.d

EXPOSE 4646 4647 4648 4648/udp

ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]
