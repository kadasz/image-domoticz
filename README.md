# image-domoticz
Install and setup Domoticz usig docker container 

## Pre requirements

- installed [docker][1] 
- installed [git][2]

## How use this image

### Build the image

```
git clone https://github.com/kadasz/image-domoticz.git
cd image-domoticz
docker build -t image-domoticz .
```

## More Info
- about parent image: https://github.com/phusion/baseimage-docker
- about dockerized service: http://www.domoticz.com

[1]:https://www.docker.com/get-started
[2]:https://pl.atlassian.com/git/tutorials/install-git
