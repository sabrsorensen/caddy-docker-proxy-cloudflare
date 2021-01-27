FROM caddy:2 as base

ARG BUILD_DATE="unknown"
ARG COMMIT_AUTHOR="unknown"
ARG VCS_REF="unknown"
ARG VCS_URL="unknown"

LABEL maintainer=${COMMIT_AUTHOR} \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-url=${VCS_URL} \
    org.label-schema.build-date=${BUILD_DATE}

FROM caddy:2-builder AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN caddy-builder \
    github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
    github.com/caddy-dns/cloudflare \
    github.com/sjtug/caddy2-filter

FROM base

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]