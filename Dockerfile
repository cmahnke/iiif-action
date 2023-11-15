# syntax=docker/dockerfile:experimental

FROM alpine:3.18

ARG ADDITIONAL_DEPS=""
ARG GIT_TAG="v8.15.0"

LABEL maintainer="cmahnke@gmail.com"
LABEL "com.github.actions.name"="GitHub Actions IIIF Generator"
LABEL "com.github.actions.description"="This is a simple GitHub Action to generate IIIF deriavtes using libvips"
LABEL org.opencontainers.image.source https://github.com/cmahnke/iiif-action

ENV BUILD_DEPS="make autoconf meson libjpeg-turbo-dev clang-dev g++ musl-dev git lcms2-dev librsvg-dev libexif-dev libwebp-dev \
                orc-dev pango-dev libgsf-dev libpng-dev glib-dev gtk-doc libtool imagemagick-dev gobject-introspection-dev \
                poppler-dev libheif-dev openjpeg-dev cgif-dev libimagequant-dev cfitsio-dev openexr-dev libarchive-dev" \
    RUN_DEPS="tiff libpng libwebp giflib libavif libjpeg-turbo brotli-libs libstdc++ libatomic libgsf libexif orc pango \
              librsvg lcms2 gettext imagemagick poppler-glib libheif openjpeg cgif libimagequant cfitsio openexr-libopenexr libarchive" \
    BUILD_CONTEXT=/mnt/build-context \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://github.com/libvips/libvips.git"

RUN --mount=target=/mnt/build-context \
# Check if JXL is already present
    if ls /usr/lib/libjxl* 1> /dev/null 2>&1; then \
      mkdir -p $BUILD_DIR/tmp && \
      cp -p /usr/lib/libjxl* $BUILD_DIR/tmp/ ; \
    fi && \
    apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS $ADDITIONAL_DEPS && \
    if ls $BUILD_DIR/tmp/libjxl* 1> /dev/null 2>&1; then \
      mkdir -p $BUILD_DIR/tmp && \
      cp -p $BUILD_DIR/tmp/libjxl* /usr/lib/ ; \
    fi && \
    mkdir -p $BUILD_DIR && \
# Set configuration
    cp -r $BUILD_CONTEXT/entrypoint.sh / && \
# Get source and compile
    cd $BUILD_DIR && \
    git config --global advice.detachedHead false && \
    git clone --depth 1 --branch $GIT_TAG $GIT_URL && \
    cd libvips && \
    export CC=clang CXX=clang++ && \
    meson build --buildtype=release --prefix=/usr && \
    cd build && \
    meson compile && \
    meson install && \
# Cleanup
    cd / && rm -rf $BUILD_DIR && \
    apk del $BUILD_DEPS libjpeg && \
    rm -rf /var/cache/apk/* /root/.cache


ENTRYPOINT ["/entrypoint.sh"]
