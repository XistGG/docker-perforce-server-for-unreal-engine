#!/bin/env bash
set -e
SYSTEM_UPGRADE="${SYSTEM_UPGRADE:-1}"

# Test to see if first time setup has been completed
IsFirstTimeComplete=0
if [ -f /root/.SystemUpdate.first ]; then
  IsFirstTimeComplete=1
fi

cat <<__EOF
system-update.sh:
  IsFirstTimeComplete=$IsFirstTimeComplete
  SYSTEM_UPGRADE=$SYSTEM_UPGRADE
__EOF


######################################################################
##  First Time Setup
######################################################################

if [ "x$IsFirstTimeComplete" = "x0" ]; then

  ######################################################################
  ##  Install System Prerequisites
  ######################################################################

  apt-get -y update
  apt-get -y install gpg
  apt-get -y install wget
  apt-get -y install libterm-readline-gnu-perl

  ######################################################################
  ##  Set up Perforce Packages & Install helix-p4d Package
  ######################################################################

  wget -qO - https://package.perforce.com/perforce.pubkey \
    | gpg --dearmor \
    > /usr/share/keyrings/perforce.gpg

  cat > /etc/apt/sources.list.d/perforce.list <<EOF
deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu jammy release
EOF

  # Update again, we just modified package sources
  apt-get -y update
  apt-get -y install helix-p4d

  ######################################################################
  ##  Done with First Time Setup
  ######################################################################

  date > /root/.SystemUpdate.first

  # FORCE SYSTEM_UPGRADE=1 for first time setup
  SYSTEM_UPGRADE=1

fi


######################################################################
##  Every Time Container Starts
######################################################################

# If we want to update, and we haven't yet updated, then update
if [ "x$SYSTEM_UPGRADE" = "x1" ] && [ ! -f /root/.SystemUpdate.last ]; then

  apt-get -y update

  apt-get -y upgrade

  date > /root/.SystemUpdate.last

else

  echo "Skipping System Upgrade..."
  [ -f /root/.SystemUpdate.last ] && echo "Last Upgrade: $(cat /root/.SystemUpdate.last)"

fi
