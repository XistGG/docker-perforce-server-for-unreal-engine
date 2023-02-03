# Based on Ubuntu Jammy, which should be reasonably stable
# https://hub.docker.com/_/ubuntu
FROM ubuntu:jammy
MAINTAINER Xist.GG <xist@xist.gg>

# SYSTEM_UPDATE=(1|0)
# Whether or not to update the base Ubuntu system on startup
ENV SYSTEM_UPDATE 0

# setenv for setup-perforce.sh, we want CASE INSENSITIVE filenames for Perforce
# (used by setup-perforce.sh)
ENV CASE_INSENSITIVE 1

ENV container docker

# ...

EXPOSE 1666
ENV NAME p4depot
ENV P4CONFIG .p4config
ENV DATAVOLUME /data
ENV P4PORT 1666
ENV P4USER p4admin
VOLUME ["$DATAVOLUME"]

ADD ./p4-users.txt /root/
ADD ./p4-groups.txt /root/
ADD ./p4-protect.txt /root/

#

COPY --chmod=0755 ./setup-perforce.sh /usr/local/bin/
COPY --chmod=0755 ./system-update.sh  /usr/local/bin/

COPY --chmod=0755 ./run.sh  /

CMD ["/run.sh"]
