#!/bin/bash

export NAME="${NAME:-p4depot}"

cat <<__EOF
run.sh:
  NAME=$NAME
  DATAVOLUME=$DATAVOLUME
__EOF


# If env says so, perform a system update or warn
/usr/local/bin/system-update.sh || echo "Warning: System Update failed" 1>&2

# Initialize Perforce
/usr/local/bin/setup-perforce.sh || echo "Error: setup-perforce.sh failed" 1>&2

sleep 2

exec /usr/bin/tail --pid=$(cat /var/run/p4d.$NAME.pid) -F "$DATAVOLUME/$NAME/logs/log"


# Run container forever
while true; do
  sleep 6000
done
