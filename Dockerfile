FROM caddy:2-builder AS builder
ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer=825813+sabrsorensen@users.noreply.github.com \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/sabrsorensen/caddy-docker-proxy-cloudflare.git"


RUN apk add --no-cache \
    gcc \
    musl-dev

RUN caddy-builder \
    github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
    github.com/caddy-dns/cloudflare

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
