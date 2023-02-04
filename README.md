
# Docker: Perforce Server for Unreal Engine

This is the Xist.GG Docker config to set up a Perforce Server
for development in Unreal Engine.

This will intialize P4D with Xist's
[Perforce Setup](https://github.com/XistGG/Perforce-Setup)
`typemap` for Unreal Engine projects.

Based on Ubuntu `jammy` which should be relatively stable.

## Usage


### Build Image

If you are deploying your container on the network, make sure you give it
your public key so you can ssh into it as user `perforce` using that key.

```powershell
# cd into this Git repo clone directory to build
docker build . -t=p4-xist `
  --build-arg PUBLIC_SSH_KEY="Your Public Key Here"
```


### Run Container

In this example we expose ssh port `22` in addition to p4 port `1666`.
Local port is 42k, obviously.  `;)`

You'll need to set the appropriate names and password.

```powershell
# after having built the image, run a container with ENV
docker run `
  --env=P4PASSWD="Your admin P4 Password Here" `
  --hostname=docker-p4 `
  --env=NAME=XistP4 `
  -p 42022:22 `
  -p 42666:1666 `
  --env=SYSTEM_UPGRADE=0 `
  --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin `
  --env=DATAVOLUME=/data `
  --volume=/data `
  --runtime=runc `
  -d p4-xist:latest
```


### Save Image

```powershell
# Save this image to the NAS
docker save p4-xist -o \\NAS\Dev\Perforce\Docker\p4-xist.tar
```


## Thanks

Thanks to [froyok]()
for the excellent blog covering the topic of
[How to Install P4D into a Docker Container]((https://www.froyok.fr/blog/2018-09-setting-up-perforce-with-docker-for-unreal-engine-4/)).

Thanks to [ambakshi](https://github.com/ambakshi/)
for providing the [base repo](https://github.com/ambakshi/docker-perforce/tree/master/perforce-server)
that inspired and provided initial code for this one.
