#!/usr/bin/with-contenv bash

#
# Automatic failmode script setup
#

if [ -z "$FAIL_MODE" ]; then
	exit 0
fi

services=() # List of services

if [ -z "$FAIL_MODE_SERVICE" ]; then
	# Populate list of services
	for service in /etc/services.d/*/; do
    service=$(echo $service|sed -r 's/\/etc\/services\.d\/(\w*)\/?/\1/')
		# Ignore specified services
		if [[ "$FAIL_MODE_SERVICE_IGNORE" =~ \s*$service\s* ]]; then
			continue
		fi
		# Add service to the list
		services+=("$service")
	done
else
	for service in $FAIL_MODE_SERVICE; do
		# Ignore specified services
		if [[ "$FAIL_MODE_SERVICE_IGNORE" =~ \s*$service\s* ]]; then
			continue
		fi
		# Add service to the list
		services+=("$service")
	done
fi

# Install finish files
for service in $services; do
	# Check if finish script for service already exists
	if [ -f "/etc/services.d/$service/finish" ]; then
		continue # Skip
	fi
  
	cp /usr/local/etc/bi/generic-finish.sh /etc/services.d/$service/finish
	sed -i -e "s/#SERVICENAME/service_name=\"$service\"/g" /etc/services.d/$service/finish
	chmod +x /etc/services.d/$service/finish
done
