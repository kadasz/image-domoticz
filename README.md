# image-domoticz
Install and setup Domoticz usig docker container 

## Pre requirements

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
docker build -t image-domoticz .
```


__NOTE! Is recommended use builded image from dockerhub because the domoticz compiling process takes a long time.__


## Credits and More Info
- about parent image: https://github.com/phusion/baseimage-docker
- about dockerized service: http://www.domoticz.com

[1]:https://www.docker.com/get-started
[2]:https://pl.atlassian.com/git/tutorials/install-git
