# smokeping

This is a derivate of **LinuxServer.io's Smokeping** docker image.

This image is derived from the upstream image, and adds functionality for file change monitoring on the /config directory.
Upon any detected file change (i.e. a file rewrite), the smokeping service would be restartet to read the config.


## motivation

**Smokeping** does not provide a functionality to monitor for changes in its config files on its own.
As such, whenever the config files are being updated, a service reload is needed.

This becomes a huge drawback if you [integrate Smokeping with LibreNMS](https://docs.librenms.org/Extensions/Smokeping/) to generate the config files.

There's several ways to address this:

* use cron, and perform timed reloads
* use inotify and perform reloads only upon file contents changes

I opted to go for **inotify** to monitor the **/config** directory, and reload Smokeping conditionally.
There's one drawback however: inotify only works as long as the **/config** directory is kept local, or mounted as a volume from the Docker host into the container.
If the volume is mounted from a remove NFS server, however, **inotify** won't work. Since file changes done from outside the container wont get propagated into the container. 

This mod thus not only integrates **inotify**, but also comes with a bash script, which performs checksum based monitoring on the **/config** directory, if it was mounted from an NFS server. 


## how to use

pull as usual:
 
```
docker pull gpdm/smokeping[:<tag>]
```

tags:
* **latest** for most recent (but potentially most broken / unstable) build
* other version-specific tags (if any) for frozen / stable builds

then run it as follows:

```
docker run -d \
   --name=smokeping \
   -e PUID=1000 \
   -e PGID=1000 \
   -e TZ=Europe/London \
   -p 80:80 \
   -v </path/to/smokeping/config>:/config \
   -v </path/to/smokeping/data>:/data \
   --restart unless-stopped \
   gpdm/smokeping[:tag]
```

All arguments as noted on the [upstream](https://github.com/linuxserver/docker-smokeping)  are supported as well.

