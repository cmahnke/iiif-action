FROM alpine:3.12

ENV BUILD_DEPS="make go git" \
    BUILD_DIR=/tmp/build

RUN apk --update upgrade && \
    apk add --no-cache $BUILD_DEPS && \
    mkdir -p $BUILD_DIR && \
    cd $BUILD_DIR && \
    git clone https://github.com/go-iiif/go-iiif.git && \
    cd go-iiif && \
    make cli-tools && \
    cp bin/* /usr/local/bin && \
    apk del $BUILD_DEPS && \
    cd / && \
    rm -rf $BUILD_DIR
