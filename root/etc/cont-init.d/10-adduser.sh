#!/usr/bin/with-contenv bash

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

# Fix directory permissions
if [ -n "$PUID" ] || [ -n "$PGID" ]; then
  chown $CONTAINER_USER:$CONTAINER_USER /app /config /defaults /log
fi
