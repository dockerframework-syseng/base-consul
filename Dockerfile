ARG TAG

FROM zerolabssyseng/base:${TAG:-latest}
MAINTAINER "System Engineer (SysEng)"

ENV CONSULTEMPLATE_VERSION=0.22.0

RUN mkdir -p /var/lib/consul && \
    addgroup -g 500 -S consul && \
    adduser -u 500 -S -D -g "" -G consul -s /sbin/nologin -h /var/lib/consul consul && \
    chown consul:consul /var/lib/consul

RUN apk add --update zip && \
    curl -sSL https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE_VERSION}/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.zip \
        -o /tmp/consul-template.zip && \
    unzip /tmp/consul-template.zip -d /bin && \
    rm /tmp/consul-template.zip && \
    apk del zip && \
    rm -rf /var/cache/apk/*

COPY rootfs/ /

HEALTHCHECK CMD /usr/sbin/container-check || exit 1
