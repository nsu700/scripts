#!/bin/bash
docker run -d \
  --name=openssh-server \
  --hostname=openssh-server `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Aisa/Hong_Kong \
  -e SUDO_ACCESS=false `#optional` \
  -e PASSWORD_ACCESS=true `#optional` \
  -e USER_PASSWORD=password `#optional` \
  -e USER_NAME=jumuser `#optional` \
  -p 2222:2222 \
  --restart unless-stopped \
  lscr.io/linuxserver/openssh-server
