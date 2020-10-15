Experimental GitHub Action for generating derivates suitable for IIIF Image viewer
==================================================================================

This action uses [LibVIPS](https://github.com/libvips/libvips) for performance reasons. You can use the subcommand [`dzsave`](https://libvips.github.io/libvips/API/current/Making-image-pyramids.md.html) to generate IIIF derivates

# Building

```
DOCKER_BUILDKIT=1 docker build -t iiif-action .
```

Building with complete output:

```
BUILDKIT_PROGRESS=plain DOCKER_BUILDKIT=1 docker build -t iiif-action .
```

# Getting the image from GitHub

```
docker pull docker.pkg.github.com/cmahnke/iiif-action/iiif-action:main
```

# Running locally

These examples are using the provided test image.

## Running using the locally build image

```
docker run -v `pwd`:`pwd` -it iiif-action sh -c "vips dzsave `pwd`/test/2010_02-March-April_Whaling_01.jpg `pwd`/test/  -t 512 --layout iiif --id '.'"
```

## Running using the image from GitHub

```
docker run -v `pwd`:`pwd` -it docker.pkg.github.com/cmahnke/iiif-action/iiif-action:main sh -c "vips dzsave `pwd`/test/2010_02-March-April_Whaling_01.jpg `pwd`/test/  -t 512 --layout iiif --id '.'"
```

## Resulting programs

The compiled binaries reside in `/usr/local/bin`, see the [documentation](https://libvips.github.io/libvips/API/current/).
