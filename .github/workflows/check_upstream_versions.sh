#!/bin/bash

docker pull caddy
docker pull caddy:builder
docker pull ghcr.io/$GITHUB_REPOSITORY

image_caddy_ref=`docker image inspect --format '{{index .Config.Labels "caddy_ref"}}' ghcr.io/$GITHUB_REPOSITORY`
image_caddy_builder_ref=`docker image inspect --format '{{index .Config.Labels "caddy_builder_ref"}}' ghcr.io/$GITHUB_REPOSITORY`
image_docker_proxy_ref=`docker image inspect --format '{{index .Config.Labels "docker_proxy_ref"}}' ghcr.io/$GITHUB_REPOSITORY`
image_caddy_cloudflare_ref=`docker image inspect --format '{{index .Config.Labels "caddy_cloudflare_ref"}}' ghcr.io/$GITHUB_REPOSITORY`
image_filter_ref=`docker image inspect --format '{{index .Config.Labels "filter_ref"}}' ghcr.io/$GITHUB_REPOSITORY`

current_caddy_ref=`docker image inspect --format '{{index .Id}}' caddy`
current_caddy_builder_ref=`docker image inspect --format '{{index .Id}}' caddy:builder`
current_docker_proxy_ref=`curl -sX GET "https://api.github.com/repos/lucaslorentz/caddy-docker-proxy/commits/master" | jq '.sha' | tr -d '"'`
current_caddy_cloudflare_ref=`curl -sX GET "https://api.github.com/repos/caddy-dns/cloudflare/commits/master" | jq '.sha' | tr -d '"'`
current_filter_ref=`curl -sX GET "https://api.github.com/repos/sjtug/caddy2-filter/commits/master" | jq '.sha' | tr -d '"'`

if [ $image_caddy_ref != $current_caddy_ref ]
then
    echo "New version of caddy is available."
    build=1
fi
if [ $image_caddy_builder_ref != $current_caddy_builder_ref ]
then
    echo "New version of caddy-builder is available."
    build=1
fi
if [ $image_docker_proxy_ref != $current_docker_proxy_ref ]
then
    echo "New version of caddy-docker-proxy is available."
    build=1
fi
if [ $image_caddy_cloudflare_ref != $current_caddy_cloudflare_ref ]
then
    echo "New version of caddy-dns/cloudflare is available."
    build=1
fi
if [ $image_filter_ref != $current_filter_ref ]
then
    echo "New version of caddy2-filter is available."
    build=1
fi

if [[ $build ]]
then
    echo "Triggering build."
    echo "build=true" >> $GITHUB_OUTPUT
else
    echo "No build needed."
    echo "build=false" >> $GITHUB_OUTPUT
fi
