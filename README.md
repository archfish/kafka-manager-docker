# kafka-manager-docker
Dockerfile for kafka-manager using alpine jre 11

## get kafka-manager

```shell
cd /tmp

CMAK_VERSION=3.0.0.4
CMAK_RELEASE_FILE=cmak-${CMAK_VERSION}.zip

wget https://github.com/yahoo/CMAK/releases/download/${CMAK_VERSION}/${CMAK_RELEASE_FILE}

unzip CMAK_RELEASE_FILE
```

## build images

```shell
docker build -t kafka-manager:alpine .
```
