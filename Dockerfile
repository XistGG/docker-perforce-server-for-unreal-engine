
# Based on Ubuntu Jammy, which should be reasonably stable
# https://hub.docker.com/_/ubuntu
FROM ubuntu:jammy
MAINTAINER Xist.GG <xist@xist.gg>

# SYSTEM_UPGRADE=(1|0)
# Whether or not to update the base Ubuntu system on startup
# Recommended: Set = 1
ENV SYSTEM_UPGRADE=0

# setenv for setup-perforce.sh, we want CASE INSENSITIVE filenames for Perforce
# (used by setup-perforce.sh)
ENV CASE_INSENSITIVE=1

ENV container docker

# ssh

# Initial set of allowed keys for 'perforce' user ssh access.
# If you leave this blank, ssh will not be enabled.
# Recommended: Set it to your public ssh key.
ARG PUBLIC_SSH_KEY=""
ENV PUBLIC_SSH_KEY=$PUBLIC_SSH_KEY

EXPOSE 22

# perforce

EXPOSE 1666
ENV NAME p4depot
ENV P4CONFIG .p4config
ENV DATAVOLUME /data
ENV P4PORT 1666
ENV P4USER admin
VOLUME ["$DATAVOLUME"]

COPY --chmod=0644 p4-*.txt /root/

#

COPY --chmod=0755 ./setup-perforce.sh /usr/local/bin/
COPY --chmod=0755 ./setup-ssh.sh /usr/local/bin/
COPY --chmod=0755 ./system-update.sh  /usr/local/bin/

COPY --chmod=0755 ./run.sh  /

CMD ["/run.sh"]
