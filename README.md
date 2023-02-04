
# Docker: Perforce Server for Unreal Engine

This is the Xist.GG Docker config to set up a Perforce Server
for development in Unreal Engine.

This will intialize P4D with Xist's
[Perforce Setup](https://github.com/XistGG/Perforce-Setup)
`typemap` for Unreal Engine projects.

Based on Ubuntu `jammy` which should be relatively stable.

## Usage

```powershell
# with this repo as current directory
docker build . -t=p4-xist `
  --build-arg PUBLIC_SSH_KEY="Your Public Key Here"
```


```powershell
# after having built the image, run a container with ENV
docker run `
  -p 42022:22 `
  -p 42666:1666 `
  --env=P4PASSWD="Your admin P4 Password Here" `
  --env=PUBLIC_SSH_KEY="Your Public Key Here if you want SSH to be enabled" `
  --hostname=docker-p4 `
  --env=NAME=xistp4 `
  --env=DATAVOLUME=/data `
  --volume=/data `
  --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin `
  --runtime=runc `
  -d p4-xist:latest
```

## Thanks

Thanks to [froyok]()
for the excellent blog covering the topic of
[How to Install P4D into a Docker Container]((https://www.froyok.fr/blog/2018-09-setting-up-perforce-with-docker-for-unreal-engine-4/)).

Thanks to [ambakshi](https://github.com/ambakshi/)
for providing the [base repo](https://github.com/ambakshi/docker-perforce/tree/master/perforce-server)
that inspired and provided initial code for this one.
