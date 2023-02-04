#!/bin/env bash

export NAME="${NAME:-p4depot}"
export PUBLIC_SSH_KEY="${PUBLIC_SSH_KEY:-}"
export SYSTEM_UPGRADE="${SYSTEM_UPGRADE:-1}"

cat <<__EOF
run.sh:
  NAME=$NAME
  DATAVOLUME=$DATAVOLUME
  SYSTEM_UPGRADE=$SYSTEM_UPGRADE
  PUBLIC_SSH_KEY=$PUBLIC_SSH_KEY
__EOF


# If env says so, perform a system update or warn
/usr/local/bin/system-update.sh || echo "Warning: System Update failed" 1>&2


# Initialize Perforce
/usr/local/bin/setup-perforce.sh || echo "Error: setup-perforce.sh failed" 1>&2


# Set up SSH access if we have a public key
/usr/local/bin/setup-ssh.sh || echo "Error: setup-ssh.sh failed" 1>&2


# Tail p4d log for eternity
sleep 2
exec /usr/bin/tail --pid=$(cat /var/run/p4d.$NAME.pid) -F "$DATAVOLUME/$NAME/logs/log"


# Run container forever
while true; do
  sleep 6000
done
