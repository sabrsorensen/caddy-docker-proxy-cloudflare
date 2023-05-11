#!/bin/bash

docker pull caddy
docker pull caddy:builder

docker build \
    --tag ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7} \
    --tag ghcr.io/${GITHUB_REPOSITORY}:latest \
    --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg COMMIT_AUTHOR="$(git log -1 --pretty=format:'%ae')" \
    --build-arg VCS_REF="${GITHUB_SHA}" \
    --build-arg VCS_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}" \
    --build-arg CADDY_REF="$(docker image inspect --format '{{json .}}' caddy | jq -r '. | .Id')" \
    --build-arg CADDY_BUILDER_REF="$(docker image inspect --format '{{json .}}' caddy:builder | jq -r '. | .Id')" \
    --build-arg DOCKER_PROXY_REF="$(curl -sX GET "https://api.github.com/repos/lucaslorentz/caddy-docker-proxy/commits/master" | jq '.sha' | tr -d '"')" \
    --build-arg CADDY_CLOUDFLARE_REF="$(curl -sX GET "https://api.github.com/repos/caddy-dns/cloudflare/commits/master" | jq '.sha' | tr -d '"')" \
    --build-arg FILTER_REF="$(curl -sX GET "https://api.github.com/repos/sjtug/caddy2-filter/commits/master" | jq '.sha' | tr -d '"')" \
    --file ./Dockerfile ./

docker push ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}
docker push ghcr.io/${GITHUB_REPOSITORY}:latest
