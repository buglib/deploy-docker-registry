#!/bin/bash

mkdir -p data
docker run \
    -d \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    -v `pwd`/certs:/certs \
    -v `pwd`/data:/var/lib/registry/docker/registry/v2 \
    -p 5000:5000 \
    --restart=always \
    --name registryd \
    registry:2