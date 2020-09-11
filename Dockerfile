# syntax=docker/dockerfile:experimental

FROM alpine:3.12

LABEL maintainer="cmahnke@gmail.com"

ENV BUILD_DEPS="make autoconf automake gcc g++ musl-dev git lcms2-dev librsvg-dev libexif-dev libwebp-dev orc-dev pango-dev libgsf-dev libpng-dev glib-dev gtk-doc libtool imagemagick-dev gobject-introspection-dev poppler-dev" \
    RUN_DEPS="tiff libpng libjpeg libgsf libexif libwebp orc pango librsvg lcms2 glib gettext imagemagick poppler-glib" \
    BUILD_CONTEXT=/mnt/build-context \
    BUILD_DIR=/tmp/build \
    GIT_URL="https://github.com/libvips/libvips.git" \
    GIT_TAG="v8.10.1"

RUN --mount=target=/mnt/build-context \
    apk --update upgrade && \
    apk add --no-cache $RUN_DEPS $BUILD_DEPS && \
    mkdir -p $BUILD_DIR $CONF_DIR && \
# Set configuration
    cp -r $BUILD_CONTEXT/entrypoint.sh / && \
# Get source and compile
    cd $BUILD_DIR && \
    git clone $GIT_URL && \
    cd libvips && \
    git checkout $GIT_TAG && \
    ./autogen.sh && \
    make -j 5 && \
    make install && \
# Cleanup
    cd / && rm -rf $BUILD_DIR && \
    apk del $BUILD_DEPS


ENTRYPOINT ["/entrypoint.sh"]
