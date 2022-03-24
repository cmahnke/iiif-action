# syntax=docker/dockerfile:experimental

FROM alpine:3.15.2

ARG ADDITIONAL_DEPS=""
ARG GIT_TAG="v8.11.1"

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions IIIF Generator"
LABEL "com.github.actions.description"="This is a simple GitHub Action to generate IIIF deriavtes using libvips"
LABEL org.opencontainers.image.source https://github.com/cmahnke/iiif-action

ENV BUILD_DEPS="make autoconf libjpeg-turbo-dev automake gcc g++ musl-dev git lcms2-dev librsvg-dev libexif-dev libwebp-dev orc-dev pango-dev libgsf-dev libpng-dev glib-dev gtk-doc libtool imagemagick-dev gobject-introspection-dev poppler-dev libheif-dev openjpeg-dev openexr-dev" \
    RUN_DEPS="tiff libpng libjpeg-turbo libgsf libexif libwebp orc pango librsvg lcms2 gettext imagemagick poppler-glib libheif openjpeg openexr" \
    BUILD_CONTEXT=/mnt/build-context \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://github.com/libvips/libvips.git"

RUN --mount=target=/mnt/build-context \
    apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS $ADDITIONAL_DEPS && \
    mkdir -p $BUILD_DIR && \
# Set configuration
    cp -r $BUILD_CONTEXT/entrypoint.sh / && \
# Get source and compile
    cd $BUILD_DIR && \
    git clone $GIT_URL && \
    cd libvips && \
    git checkout $GIT_TAG && \
    ./autogen.sh --prefix=/usr && \
    make -j 5 && \
    make install && \
# Cleanup
    cd / && rm -rf $BUILD_DIR && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf /var/cache/apk/* /root/.cache


ENTRYPOINT ["/entrypoint.sh"]
