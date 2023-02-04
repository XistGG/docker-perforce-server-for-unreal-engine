#!/bin/env bash
# This must run AFTER perforce has been set up
set -e
P4HOME=/opt/perforce

cat <<__EOF
setup-ssh.sh:
  PUBLIC_SSH_KEY=$PUBLIC_SSH_KEY
__EOF


if [ -z "$PUBLIC_SSH_KEY" ]; then
  # $PUBLIC_SSH_KEY is empty

  echo "SSH will not be enabled; empty PUBLIC_SSH_KEY"

else
  # $PUBLIC_SSH_KEY is NOT EMPTY, so configure ssh

  ######################################################################
  ##  Install SSH Authorized Keys
  ######################################################################

  [ -d $P4HOME/.ssh ] || mkdir $P4HOME/.ssh

  echo "$PUBLIC_SSH_KEY" > $P4HOME/.ssh/authorized_keys
  chmod 600 $P4HOME/.ssh/authorized_keys

  # Make sure perforce user owns its entire ~/.ssh dir
  chown -R perforce:perforce $P4HOME/.ssh
  chmod 700 $P4HOME/.ssh

  ######################################################################
  ##  Install SSH and Start sshd
  ######################################################################

  apt-get -y install ssh

  service ssh start

  ######################################################################
  ##  When sshing in as perforce over the network, it's required
  ##  to be able to sudo for server maintenance.
  ######################################################################

  # Install sudo
  apt-get -y install sudo

  # Add perforce user to sudo group
  usermod -aG sudo perforce

  # Allow perforce user to sudo without a password
  cat > /etc/sudoers.d/perforce <<EOF
perforce ALL=(ALL) NOPASSWD: ALL
EOF

  # Nobody should be able to change this but root
  chmod 600 /etc/sudoers.d/perforce

fi
