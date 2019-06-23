# image-domoticz
Install and setup Domoticz usig docker container 

## Pre requirements

- have Linux or macOS
- installed [docker][1] 
- installed [git][2]

## Testing

In my environment this image tested and works in docker on QNAP 

## How use this image

### Pull the image

![Docker Build](https://img.shields.io/docker/cloud/build/kadasz/image-domoticz.svg) ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/kadasz/image-domoticz.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/kadasz/image-domoticz.svg)


```
docker pull kadasz/image-domoticz
```

### Build the image

```
git clone https://github.com/kadasz/image-domoticz.git
cd image-domoticz
docker build -t kadasz/image-domoticz .
```


__NOTE! Is recommended to use `docker pull` instead of `docker build` because the building process takes a more time so download image from [Docker Hub][3] will be much faster.__

### Run a container
#### Simply way just run command below:

```
docker run -d --name domoticz --hostname domoticz -p 8888:8080 kadasz/image-domoticz /sbin/my_init
```
__You can change the port `8888` to any other one.__

#### With using persistent storage for domoticz home directory.
First, create the directory on host and set right permissions for it:

```
mkdir -p ~/domoticz/{logs,plugins,db}
chmod -R o+rxw ~/domoticz/{logs,plugins,db}
```
__Remember, that you can change `~/domoticz/config` as needed for your particular needs!__

Next, crete a container hosting the volume mappings:

```
docker run -d --name domoticz --hostname domoticz --privileged -p 8888:8080 \
-v ~/domoticz/plugins/:/opt/domoticz/plugins \
-v ~/domoticz/logs/:/opt/domoticz/logs \
-v ~/domoticz/db/:/opt/domoticz/db \
kadasz/image-domoticz /sbin/my_init
```

Now, check that domoticz has started:

```
docker exec -it domoticz head /opt/domoticz/logs/domoticz.log
```

you will see output similar to below:
```
2019-04-25 16:19:07.426  Status: Domoticz V4.9701 (c)2012-2018 GizMoCuz
2019-04-25 16:19:07.433  Status: Build Hash: b47a877f, Date: 2018-06-23 16:27:56
2019-04-25 16:19:07.433  Status: Startup Path: /opt/domoticz/
2019-04-25 16:19:07.472  BuildManifest: Created directory /opt/domoticz/plugins/
2019-04-25 16:19:07.491  Status: PluginSystem: Started, Python version '3.5.2'.
2019-04-25 16:19:07.493  Active notification Subsystems: gcm, http (2/13)
2019-04-25 16:19:07.497  Status: WebServer(HTTP) started on address: 0.0.0.0 with port 8888
```
or after about one minute run a command"

```
docker inspect --format '{{.State.Health.Status}}' domoticz
healthy
```
if you see `healthy`, everything works well!

#### Go to Domoticz
Enter in your browser at address:
```
http://localhost:8888/
```

### Parameterize environment variables
You can set or change environment variables such as:

| Parameter | Function |
| :----: | --- |
| `-e TZ=Europe/London` | specify a timezone to use e.g. Europe/London, default is Europe/Warsaw|

## Credits and More Info
- about parent image: https://github.com/phusion/baseimage-docker
- about dockerized service: http://www.domoticz.com

[1]:https://www.docker.com/get-started
[2]:https://pl.atlassian.com/git/tutorials/install-git
[3]:https://cloud.docker.com/repository/registry-1.docker.io/kadasz/image-domoticz
