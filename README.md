Experimental GitHub Action for generating derivates suitable for IIIF Image viewer
==================================================================================

# Building

```
DOCKER_BUILDKIT=1 docker build -t iiif-action .
```

## Resulting programs

The following binaries reside in `/usr/local/bin`:

* `iiif-dump-config`
* `iiif-process`
* `iiif-process-and-tile`
* `iiif-server`
* `iiif-tile-seed`
* `iiif-transform`

# Running the tile generator

```
docker run -it iiif-action /usr/local/bin/iiif-tile-seed  page58.jpg
```


# Improving performance

## Increase number of parallel processes

You can set the number of parallel process by passing the `-processes` flag. One can use 2 * number of cores.

To get the number of cores just run `dmidecode -t processor`. This tool is also [available on OS X](http://cavaliercoder.com/blog/dmidecode-for-apple-osx.html).
