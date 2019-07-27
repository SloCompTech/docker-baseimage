#!/usr/bin/with-contenv bash

# Change user's GID if specifed
if [ -n "$PGID" ]; then
  echo "GID fix"
  groupmod -o -g "$PGID" abc
fi

# Change user's PID if specified
if [ -n "$PUID" ]; then
  echo "PID fix"
  usermod -o -u "$PUID" abc
fi

echo "
-------------------------------------
GID/UID
-------------------------------------"
echo "
User uid:    $(id -u abc) (abc)
User gid:    $(id -g abc) (abc)
-------------------------------------
"

# Fix directory permissions
if [ -n "$PUID" ] || [ -n "$PGID" ]; then
  chown abc:abc /app /config /defaults /log
fi
