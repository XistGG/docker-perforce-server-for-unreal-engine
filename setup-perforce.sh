#!/bin/env bash
set -e
export NAME="${NAME:-p4depot}"
export CASE_INSENSITIVE="${CASE_INSENSITIVE:-1}"
export P4ROOT="${DATAVOLUME}/${NAME}"

cat <<__EOF
setup-perforce.sh:
  CASE_INSENSITIVE=$CASE_INSENSITIVE
  P4ROOT=$P4ROOT
__EOF

if [ ! -d $DATAVOLUME/etc ]; then
    echo >&2 "First time installation, copying configuration from /etc/perforce to $DATAVOLUME/etc and relinking"
    mkdir -p $DATAVOLUME/etc
    cp -r /etc/perforce/* $DATAVOLUME/etc/
    FRESHINSTALL=1
fi

mv /etc/perforce /etc/perforce.orig
ln -s $DATAVOLUME/etc /etc/perforce

if [ -z "$P4PASSWD" ]; then
    P4PASSWD="pass12349ers!"
fi

# This is hardcoded in configure-helix-p4d.sh :(
P4SSLDIR="$P4ROOT/ssl"

for DIR in $P4ROOT $P4SSLDIR; do
    mkdir -m 0700 -p "$DIR"
    chown perforce:perforce "$DIR"
done

if ! p4dctl list 2>/dev/null | grep -q $NAME; then
    /opt/perforce/sbin/configure-helix-p4d.sh $NAME -n -p $P4PORT -r $P4ROOT -u $P4USER -P "${P4PASSWD}" --case $CASE_INSENSITIVE
fi

p4dctl start -t p4d $NAME
if echo "$P4PORT" | grep -q '^ssl:'; then
    p4 trust -y
fi

cat > ~perforce/.p4config <<EOF
P4USER=$P4USER
P4PORT=$P4PORT
P4PASSWD=$P4PASSWD
EOF
chmod 0600 ~perforce/.p4config
chown perforce:perforce ~perforce/.p4config

p4 login <<EOF
$P4PASSWD
EOF

if [ "$FRESHINSTALL" = "1" ]; then

    echo "First time installation, setting up defaults for p4 user, group and protect tables"

    # Download the latest XistGG typemap
    wget -qO - https://raw.githubusercontent.com/XistGG/Perforce-Setup/main/typemap.txt \
        > /root/p4-typemap.txt

    ## Load up the default tables
    p4 user -i < /root/p4-admin-user.txt
    p4 group -i < /root/p4-admin-group.txt
    p4 group -i < /root/p4-user-group.txt
    p4 protect -i < /root/p4-protect.txt

    # disable automatic user account creation
    p4 configure set lbr.proxy.case=1

    # disable unauthorized viewing of Perforce user list
    p4 configure set run.users.authorize=1

    # disable unauthorized viewing of Perforce config settings
    p4 configure set dm.keys.hide=2

    # configure typemap
    p4 typemap -i < /root/p4-typemap.txt

fi

echo "   P4USER=$P4USER (the admin user)"

if [ "$P4PASSWD" == "pass12349ers!" ]; then
    echo -e "\n***** WARNING: USING DEFAULT PASSWORD ******\n"
    echo "Please change as soon as possible:"
    echo "   P4PASSWD=$P4PASSWD"
    echo -e "\n***** WARNING: USING DEFAULT PASSWORD ******\n"
fi

# exec /usr/bin/p4web -U perforce -u $P4USER -b -p $P4PORT -P "$P4PASSWD" -w 8080
