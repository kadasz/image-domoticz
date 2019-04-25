# image-domoticz
Install and setup Domoticz usig docker container 

## Pre requirements

- have Linux or macOS
- installed [docker][1] 
- installed [git][2]

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


__NOTE! Is recommended to use `docker pull` instead of `docker build` because the building process takes a more time so download image from Docker Hub will be much faster.__

### Run a container
Simply way just run command below:

```
docker run -d --name domoticz -p 8888:8080 kadasz/image-domoticz /sbin/my_init
```
__You can change the port 8888 to any other one.__

#### Go to Domoticz
```
http://your_ip:8888/
```

## Credits and More Info
- about parent image: https://github.com/phusion/baseimage-docker
- about dockerized service: http://www.domoticz.com

[1]:https://www.docker.com/get-started
[2]:https://pl.atlassian.com/git/tutorials/install-git
