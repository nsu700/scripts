#!/bin/bash

docker run -d \
--name nextcloud \
--volume /Volumes/data/Nextcloud:/var/www/html \
--restart always \
-p 80:80 \
nextcloud
