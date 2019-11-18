#
#	Base image
#	@see https://hub.docker.com/_/node
#	@see https://github.com/nodejs/docker-node/blob/master/README.md#how-to-use-this-image
#	@see https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
#	@see https://hub.docker.com/_/alpine/	
#
FROM node:10-alpine

#
#	Arguments
#
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_SRC
ARG VERSION
ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH="amd64"

#
#	Labels
#	@see https://github.com/opencontainers/image-spec/blob/master/annotations.md
#	@see https://semver.org/
#
LABEL maintainer="martin.dagarin@gmail.com" \
	org.opencontainers.image.authors="Martin Dagarin" \
	org.opencontainers.image.created=${BUILD_DATE} \
	org.opencontainers.image.description="Base image with NodeJS to package applications to production" \
	org.opencontainers.image.documentation="https://github.com/SloCompTech/docker-baseimage" \
	org.opencontainers.image.revision=${VCS_REF} \
	org.opencontainers.image.source=${VCS_SRC} \
	org.opencontainers.image.title="nodejs base image" \
	org.opencontainers.image.url="https://github.com/SloCompTech/docker-baseimage"\
	org.opencontainers.image.version=${VERSION}

#
#	Environment variables
#	@see https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
#	@see https://unix.stackexchange.com/questions/43945/whats-the-difference-between-various-term-variables
#	@see https://unix.stackexchange.com/questions/34379/is-home-but-sometimes
#

ENV CONTAINER_USER="node" \
		HOME="/root" \
		IMAGE_STACK="node" \
		NPM_CONFIG_PREFIX=/home/node/.npm-global \
		PATH=$PATH:/home/node/.npm-global/bin \
		PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
		TERM="xterm"

#
#	Install packages
#
RUN apk add --no-cache \
	bash \
	ca-certificates \
	coreutils \
	curl \
	shadow \
	tar \
	tzdata

#
#	Install s6-overlay
#	@see https://github.com/just-containers/s6-overlay
#
RUN curl -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
	tar xfz /tmp/s6-overlay.tar.gz -C / && \
	rm /tmp/s6-overlay.tar.gz

#
#	Create working structure
#
RUN mkdir -p /app /config /data /defaults /log && \
	chown $CONTAINER_USER:$CONTAINER_USER /app /config /data /defaults /log

#
#	Add local files to image
#
COPY root/ /

ENTRYPOINT ["/init"]
