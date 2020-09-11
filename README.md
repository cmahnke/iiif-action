Experimental GitHub Action for generating derivates suitable for IIIF Image viewer
==================================================================================

This action used to use [IIIF-Go](https://github.com/go-iiif/go-iiif), but for performance reasons switched to [LibVIPS]().

# Building

```
DOCKER_BUILDKIT=1 docker build -t iiif-action .
```

Building with complete output:

```
BUILDKIT_PROGRESS=plain DOCKER_BUILDKIT=1 docker build -t iiif-action .
```

## Resulting programs

The following binaries reside in `/usr/local/bin`:

You'll need `vips`.

# Running the tile generator

```
docker run -it iiif-action /usr/local/bin/iiif-tile-seed  page58.jpg
```
