#!/bin/sh
# Docker script to configure and start an Http Proxy Server
#
# DO NOT RUN THIS SCRIPT ON YOUR PC OR MAC! 
# THIS IS ONLY MEANT TO BE RUN IN A CONTAINER!
#
# This file is part of squid docker image, available at:
# https://github.com/malidong/docker-squid
# Copyright (C) 2022-2022 Stand-E Consulting <stand.e.consulting@gmail.com>
#
# This work is licensed under the The MIT License
# Unported License: https://opensource.org/licenses/MIT
#
# Attribution required: please include my name in any derivative and let me
# know how you have improved it!

# Start squid
squid

conf_dir="/home/pi/docker-squid/etc-squid"

# Get the status of setting files in /etc/squid/
previous_status=`find ${conf_dir} -type f -exec md5sum {} \; | sort -k 2 | md5sum`
current_status=`find ${conf_dir} -type f -exec md5sum {} \; | sort -k 2 | md5sum`

# If something in settings changed, reload squid.
while true
do
    sleep 300

    current_status=`find ${conf_dir} -type f -exec md5sum {} \; | sort -k 2 | md5sum`
    if [ "$previous_status" = "$current_status" ]; then
        echo "No changes on settings...Sleep 5 minutes"
    else
        echo "Changes found in settings, reload settings..."
        squid -k reconfigure
        previous_status="$current_status"
    fi
done

