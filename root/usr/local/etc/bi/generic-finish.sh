#!/usr/bin/with-contenv bash

#SERVICENAME

#
#	Service finish script
#

if [ -z "$FAIL_MODE" ]; then
  exit 0
fi

# Stop container on service fail
if [ "$FAIL_MODE" == "hard" ]; then
  exec s6-svscanctl -t /var/run/s6/services
fi

# Fail counter
if [ -n "$service_name" ] && [ "$FAIL_MODE" == "count" ] && [ -n "$FAIL_MODE_COUNT" ]; then
  count=0
  if [ -f "/tmp/service_count_$service_name" ]; then
    count=$(cat /tmp/service_count_$service_name)
	fi
	((count++))
	if [ $count -gt $FAIL_MODE_COUNT ]; then
    rm /tmp/service_count_$service_name
    exec s6-svscanctl -t /var/run/s6/services
  else
    echo $count > /tmp/service_count_$service_name
  fi
fi
