#
#	Base image
#	@see https://hub.docker.com/_/alpine/	
#
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

#
#	Arguments
#
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_SRC
ARG VERSION
ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH

#
#	Labels
#	@see https://github.com/opencontainers/image-spec/blob/master/annotations.md
#	@see https://semver.org/
#
LABEL maintainer="martin.dagarin@gmail.com" \
	org.opencontainers.image.authors="Martin Dagarin" \
	org.opencontainers.image.created=${BUILD_DATE} \
	org.opencontainers.image.description="Base image" \
	org.opencontainers.image.documentation="https://github.com/SloCompTech/docker-baseimage-alpine" \
	org.opencontainers.image.revision=${VCS_REF} \
	org.opencontainers.image.source=${VCS_SRC} \
	org.opencontainers.image.title="Base image" \
	org.opencontainers.image.url="https://github.com/SloCompTech/docker-baseimage-alpine" \
	org.opencontainers.image.version=${VERSION}

#
#	Environment variables
#	@see https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
#	@see https://unix.stackexchange.com/questions/43945/whats-the-difference-between-various-term-variables
#	@see https://unix.stackexchange.com/questions/34379/is-home-but-sometimes
#
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
	HOME="/root" \
	TERM="xterm" \
	NPM_CONFIG_PREFIX=/home/node/.npm-global \
	PATH=$PATH:/home/node/.npm-global/bin

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
#	Create user
#
RUN useradd -u 1000 -U -d /config -s /bin/false abc

#
#	Add QEMU for running arm images on amd64
#
COPY ./bin/qemu-arm-static /usr/bin/qemu-arm-static

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
RUN mkdir -p /app /config /defaults /log && \
	chown abc:abc /app /config /defaults /log

#
#	Add local files to image
#
COPY root/ /

ENTRYPOINT ["/init"]
