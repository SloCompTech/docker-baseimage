#!/usr/bin/with-contenv bash

source $CONTAINER_VARS_FILE

# Change user's GID if specifed
if [ -n "$PGID" ]; then
  echo "GID fix"
  groupmod -o -g "$PGID" $CONTAINER_USER
fi

# Change user's PID if specified
if [ -n "$PUID" ]; then
  echo "PID fix"
  usermod -o -u "$PUID" $CONTAINER_USER
fi

echo "
-------------------------------------
GID/UID
-------------------------------------"
echo "
User uid:    $(id -u $CONTAINER_USER) ($CONTAINER_USER)
User gid:    $(id -g $CONTAINER_USER) ($CONTAINER_USER)
-------------------------------------
"

# Set environment variable for running commands as CONTAINER_USER
echo "# Run as container user" >> $CONTAINER_VARS_FILE
echo "export RUNCMD=\"sudo -u ${CONTAINER_USER} -g ${CONTAINER_USER}\"" >> $CONTAINER_VARS_FILE

if [ -n "$PUID" ] || [ -n "$PGID" ]; then
  # Fix directory permissions
  [ -n "$NO_CHOWN" ] || chown $CONTAINER_USER:$CONTAINER_USER /app /config /data /defaults /log
fi
