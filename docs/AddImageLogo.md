# Add logo to the image

1. Create script called `09-logo.sh` with echo that prints your logo.

	``` bash
	#!/usr/bin/with-contenv bash
	echo "
	-------------------------------------
		 _                       
		| |                      
		| |     ___   __ _  ___  
		| |    / _ \ / _` \|/ _ \\ 
		\| \|___\| (_) \| (_\| \| (_) \|
		\|______\___/ \__, \|\\___/ 
									__/ \|      
									\|___/       
	"
	```

2. In *Dockerfile* make sure to put file in `/etc/cont-init.d`.
