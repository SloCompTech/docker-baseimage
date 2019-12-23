# Base image

This is **base image** with [s6 overlay (supervisor utils)](https://github.com/just-containers/s6-overlay) already setup. Directory structure is also setup.

## Project structure

```
root # Files copied to image started from root
Dockerfile # Image configuration
```

## Directories

Image has prepared directories:

- `/app` for **application**
- `/config` for **configuration**
- `/data` for **application data**
- `/defaults` for **default configuration** which is copied to `/config` if directory is empty
- `/log` for **logging** (often you need separated directory for logs (because you don't want to write to eg. SD card ...))

## Parameters

|**Parameter**|**Function**|
|:-----------:|:-----------|
|`-e CONTAINER_USER="abc"`|Set non-root user used in container (do not modify, already set in Dockerfile)|
|`-e NO_CHOWN=true`|Disable fixing permissions for files (implement in derived images.)|
|`-e NO_DEFAULT_CONFIG=true`|Skip setting up default config|
|`-e PUID=1000`|for UserID - see below for explanation|
|`-e PGID=1000`|for GroupID - see below for explanation|
|`-e TZ=Europe/London`|Specify a timezone|
|`-v /config`|All the config files reside here.|
|`-v /log`|All the log files reside here.|

## Environment variables

|**Variable name**|**Function**|
|:---------------:|:----------:|
|`CONTAINER_USER`|User used to run in less priviledged mode (owner of prepared directories).|
|`DOCKER_CONTAINER`|Always `true`|
|`IMAGE_STACK`|Top base image eg. alpine, nginx, node ...|

## User / Group Identifiers

When using volumes (-v flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user PUID and group PGID.  

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.  

In this instance PUID=1000 and PGID=1000, to find yours use id user as below:  

``` bash
$ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

**Note:** Default user is in most cases named **abc**.  

## Building locally

``` bash
# Build image
sudo docker build -t IMGNAME .

# Run image
sudo docker run --rm -it IMGNAME bash
```

## Issues

Submit issue [here](https://github.com/SloCompTech/docker-baseimage/issues).  

## Documentation

- [Base image from LSIO](https://github.com/linuxserver/docker-baseimage-alpine/blob/master/Dockerfile.aarch64)
- [s6-overlay](https://github.com/just-containers/s6-overlay)

## Versions

- *1.0.0* - First version
