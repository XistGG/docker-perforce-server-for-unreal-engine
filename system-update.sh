#!/bin/bash
set -e
SYSTEM_UPDATE="${SYSTEM_UPDATE:-1}"

cat <<__EOF

system-update.sh

  DATAVOLUME=$DATAVOLUME
  SYSTEM_UPDATE=$SYSTEM_UPDATE

__EOF


# If we want to update, and we haven't yet updated, then update
if [ "x$SYSTEM_UPDATE" = "x1" -a ! -f /root/.NoSystemUpdate ]; then

  apt-get -y update

  apt-get -y upgrade

  date > /root/.NoSystemUpdate

else

  echo "Skipping System Update..."

fi
