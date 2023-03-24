
# Docker: Perforce Server for Unreal Engine

This is the Xist.GG Docker config to set up a Perforce Server
for development in Unreal Engine.

This will intialize P4D with Xist's
[Perforce Setup](https://github.com/XistGG/Perforce-Setup)
`typemap` for Unreal Engine projects.

Based on Ubuntu `jammy` which should be relatively stable.

## Usage


```powershell
# Set these as you wish
$DockerTag = 'p4-xist'
$P4InstanceName = 'P4Xist'
$ContainerHostname = 'docker-p4'
```

### Build Image

If you give it an *(optional)* Public SSH Key on build, it will give this
key access to the `perforce` user account, which can `sudo`.

This effectively gives full `root` permission on the container to the key owner.

If you omit this, `ssh` will not be installed and remote access and maintenance
will not be possible.

```powershell
# cd into this Git repo clone directory to build
docker build . -t=$DockerTag `
  --build-arg PUBLIC_SSH_KEY="Your Public Key Here"
```


### Run Container

In this example we expose ssh port `22` in addition to p4 port `1666`.

Local port is 42K, obviously.  `;)`

```powershell
# after having built the image, run a container with ENV
docker run `
  --hostname=$ContainerHostname `
  --env=NAME=$P4InstanceName `
  -p 42022:22 `
  -p 42666:1666 `
  --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin `
  --env=DATAVOLUME=/data `
  --volume=/data `
  --runtime=runc `
  -d ${DockerTag}:latest
```

Note this uses the DEFAULT PASSWORD for the P4 `admin` user, so you will want to login and
change it immediately.


### Save Image

```powershell
# Save this image to the NAS
docker save $DockerTag -o \\NAS\Dev\Perforce\Docker\${DockerTag}.tar
```


## Thanks

Thanks to [froyok](https://github.com/froyok/)
for the excellent blog covering the topic of
[How to Install P4D into a Docker Container]((https://www.froyok.fr/blog/2018-09-setting-up-perforce-with-docker-for-unreal-engine-4/)).

Thanks to [ambakshi](https://github.com/ambakshi/)
for providing the [base repo](https://github.com/ambakshi/docker-perforce/tree/master/perforce-server)
that inspired and provided initial code for this one.
