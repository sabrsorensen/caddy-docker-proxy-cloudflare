# caddy-docker-proxy-cloudflare

Caddy2 with [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy) and [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)

```yml
    caddy:
        image: sabrsorensen/caddy-docker-proxy-cloudflare
        container_name: caddy
        networks:
            - net
        ports:
            - 80:80
            - 443:443
            - 2015:2015
        environment:
            - CLOUDFLARE_EMAIL=your.cloudflare@email.com
            - CLOUDFLARE_API_TOKEN=your.cloudflare.apitoken
            - CADDY_DOCKER_PROXY_SERVICE_TASKS=true
            - CADDY_DOCKER_PROCESS_CADDYFILE=true
        volumes:
            - /<path to your docker configs>/caddy/:/data/
            - /var/run/docker.sock:/var/run/docker.sock
        command: docker-proxy
        labels:
            caddy.email: "your.letsencrypt@email.com"
        restart: unless-stopped

    proxiedService:
    ...
        networks:
            - net
        ports:
            - 8080:8080
        labels:
            caddy: proxiedService.domain.tld
            caddy.reverse_proxy: "{{ upstreams http 8080 }}"
            caddy.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
    ...

    proxiedServiceWithBasicAuthOnAllRoutes:
    ...
        networks:
            - net
        ports:
            - 8081:8081
        labels:
            caddy: proxiedServiceWithBasicAuth.domain.tld
            caddy.reverse_proxy: "{{ upstreams http 8081 }}"
            caddy.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
            caddy.basicauth.<username>: "`caddy hash-password --plaintext <password>`"
    ...

    proxiedServiceWithBasicAuthOn/SecretRoute:
    ...
        networks:
            - net
        ports:
            - 8082:8082
        labels:
            caddy: proxiedServiceWithBasicAuth.domain.tld
            caddy.reverse_proxy: "{{ upstreams http 8082 }}"
            caddy.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
            caddy.basicauth./secretroute.<username>: "`caddy hash-password --plaintext <password>`"
    ...

    proxiedServiceWithMultiplePorts:
    ...
        networks:
            - net
        ports:
            - 8083:8083
            - 8084:8084
        labels:
            caddy: proxiedServiceWithMultiplePorts.domain.tld
            caddy.reverse_proxy: "{{ upstreams http 8083 8084 }}"
            caddy.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
    ...

    proxiedServiceWithMultiplePortsAndSubdomains:
    ...
        networks:
            - net
        ports:
            - 8085:8085
            - 8086:8086
        labels:
            caddy_0: proxiedServiceWithMultiplePortsAndSubdomains0.domain.tld
            caddy_0.reverse_proxy: "{{ upstreams http 8085 }}"
            caddy_0.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
            caddy_1: proxiedServiceWithMultiplePortsAndSubdomains1.domain.tld
            caddy_1.reverse_proxy: "{{ upstreams http 8086 }}"
            caddy_1.tls.dns: "cloudflare {env.CLOUDFLARE_API_TOKEN}"
    ...
```
