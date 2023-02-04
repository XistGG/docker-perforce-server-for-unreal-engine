#!/bin/env bash
# This must run AFTER perforce has been set up
set -e

cat <<__EOF
setup-ssh.sh:
  PUBLIC_SSH_KEY=$PUBLIC_SSH_KEY
__EOF


if [ -z "$PUBLIC_SSH_KEY" ]; then
  # $PUBLIC_SSH_KEY is empty

  echo "SSH will not be enabled; empty PUBLIC_SSH_KEY"

else
  # $PUBLIC_SSH_KEY is NOT EMPTY, so configure ssh

  P4HOME=/opt/perforce

  install -d -m 0700 -o perforce -g perforce $P4HOME/.ssh

  echo "$PUBLIC_SSH_KEY" > $P4HOME/.ssh/authorized_keys
  chown perforce:perforce $P4HOME/.ssh/authorized_keys
  chmod 600 $P4HOME/.ssh/authorized_keys

  apt-get -y install ssh

  service ssh start

fi
