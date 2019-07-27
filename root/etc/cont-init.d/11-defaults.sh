#!/usr/bin/with-contenv bash

#
#	Setup defaults
#

# Skip
if [ -n "$NO_DEFAULT_CONFIG" ]; then
	exit 0
fi

# Check if default configuration files exsist
if [ ! -d /defaults ] || [ -z "$(ls -A /defaults)" ]; then
	echo "No default configuration available."
	exit 0
fi

# Check if configuration directory exist
if [ ! -d /config ]; then
	exit 0
fi

# Check if files already in config directory
if [ ! -z "$(ls -A /config)" ]; then
	exit 0
fi

# Copy default configration to configuration directory
echo "Copying default configuration to configuration directory"
cp -r -p -v /defaults/* /config
chown abc:abc -R /config
