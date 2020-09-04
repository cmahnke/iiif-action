# syntax=docker/dockerfile:experimental

FROM alpine:3.12

LABEL maintainer="cmahnke@gmail.com"

ENV BUILD_DEPS="make go git" \
    BUILD_CONTEXT=/mnt/build-context \
    BUILD_DIR=/tmp/build \
    CONF_DIR=/etc/go-iiif

RUN --mount=target=/mnt/build-context \
    apk --update upgrade && \
    apk add --no-cache $BUILD_DEPS && \
    mkdir -p $BUILD_DIR $CONF_DIR && \
# Set configuration
    cp -r $BUILD_CONTEXT/config.json $CONF_DIR/ && \
# Get source and compile
    cd $BUILD_DIR && \
    git clone https://github.com/go-iiif/go-iiif.git && \
    cd go-iiif && \
    make cli-tools && \
    cp bin/* /usr/local/bin && \
    apk del $BUILD_DEPS && \
    cd / && \
    rm -rf $BUILD_DIR
