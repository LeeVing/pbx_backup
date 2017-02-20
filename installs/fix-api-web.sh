#!/usr/bin/env bash

ENV=${1:-$(hostname | cut -d '-' -f 1)}
HOSTNAME=$ENV-api-web.dev.coredial.com
CMD="sudo sed -i 's/Deny from all/Allow from all/g' /etc/httpd/sites-available/voiceaxis.conf && sudo /sbin/service httpd restart"
printf "\033[0;32m%s:\033[0m\n" "$HOSTNAME"
ssh -q $HOSTNAME $CMD