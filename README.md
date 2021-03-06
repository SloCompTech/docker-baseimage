# Base image

This is **base image** with [s6 overlay (supervisor utils)](https://github.com/just-containers/s6-overlay) already setup. Directory structure is also setup.

## Project structure

```
root # Files copied to image started from root
  etc
    cont-finish.d # See s6-overlay
    cont-init.d # See s6-overlay
    fix-attrs.d # See s6-overlay
    service.d # See s6-overlay
  usr/local/etc/bi # Base image configuration files
    vars # Base image container variables
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
|`-e FAIL_MODE="hard"`|Fail action (blank: service restart, hard: restart container on service fail, count: Try restart service inside n-times before container restart)|
|`-e FAIL_MODE_SERVICE="service1 service2"`|List of services to setup fail action|
|`-e FAIL_MODE_SERVICE_IGNORE="service1 service2"`|List of services to ignore when setting up fail action|
|`-e RUN_ROOT=true`|Disable `$RUNCMD`|
|`-e NO_CHOWN=true`|Don't re-chown prepared directories|
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
|`CONTAINER_VARS_FILE`|File where base image container variables are stored, load it with `source $CONTAINER_VARS_FILE` at the **top** of your scripts (**\*** - variables that depend on this)|
|`DOCKER_CONTAINER`|Always `true`|
|`RUNCMD`|Put it before every bash command to make sure command is run as container user (generates `sudo -u PID -g GID -E` command) **\***|

## User / Group Identifiers

When using volumes (-v flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user PUID and group PGID.  

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.  

In this instance PUID=1000 and PGID=1000, to find yours use id user as below:  

``` bash
$ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

**Note:** Default user is in most cases named **abc**.  

## Fail mode

For each service in `/etc/services.d/*/` you can manually setup **fail action** using `finish` script. But you can do this automatically by setting `FAIL_MODE`, which will dynamically generate `finish` scripts for all your services specified in `/etc/services.d/*/` (custom `finish` scripts will be left untouched).

Fail modes:

- `hard`
  - If service fails, container fails
- `count`
  - Service can fail `FAIL_MODE_COUNT` times before container fails

**Note:** You can select for which services you want to automatically setup failmode with `FAIL_MODE_SERVICE="service1 service2"`.
**Note.** You can exclude service from automatic setup with `FAIL_MODE_SERVICE_IGNORE="service1 service2"`.

## Building locally

``` bash
# Build image
sudo docker build -t IMGNAME .

# Run image
sudo docker run --rm -it IMGNAME bash
```

## Dockerhub build variables

Here are additional variables for Docker Hub build.

|**Parameter**|**Function**|
|:-----------:|:-----------|
|`IMAGE,IMAGE_<arch>`|Base image name|
|`IMAGE_<ref>_ORIG=true`|Preserve original docker tag through build.|
|`IMAGE_<ref>_SRCTAG=<source tag>`|Image source tag (if it is different from `$DOCKER_TAG`.|

## Issues

Submit issue [here](https://github.com/SloCompTech/docker-baseimage/issues).  

## Documentation

- [Base image from LSIO](https://github.com/linuxserver/docker-baseimage-alpine/blob/master/Dockerfile.aarch64)
- [s6-overlay](https://github.com/just-containers/s6-overlay)

## Versions

- *1.0.0* - First version
