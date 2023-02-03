#!/bin/bash
set -e
SYSTEM_UPGRADE="${SYSTEM_UPGRADE:-1}"

cat <<__EOF

system-update.sh

  DATAVOLUME=$DATAVOLUME
  SYSTEM_UPGRADE=$SYSTEM_UPGRADE

__EOF


# If we want to update, and we haven't yet updated, then update
if [ "x$SYSTEM_UPGRADE" = "x1" -a ! -f /root/.SystemUpdate.last ]; then

  apt-get -y update

  apt-get -y upgrade

  date > /root/.SystemUpdate.last

else

  echo "Skipping System Upgrade..."
  echo "Last Upgrade: `cat /root/.SystemUpdate.last`"

fi
