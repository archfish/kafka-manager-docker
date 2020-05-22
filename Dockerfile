#!/bin/bash

set -e

EXEC='bin/cmak -Dconfig.file=$CONFIG_FILE_PATH -Dhttp.port=$BIND_HTTP_PORT -Dapplication.home=$PWD'

if [ ! -z "$@" ]; then EXEC="$@"; fi

exec $EXEC
```

```
FROM adoptopenjdk/openjdk11:alpine-jre

WORKDIR /opt/cmak

RUN MAIN_VERSION=$(cat /etc/alpine-release | cut -d '.' -f 0-2) \
    && mv /etc/apk/repositories /etc/apk/repositories-bak \
    && { \
        echo "https://mirrors.aliyun.com/alpine/v${MAIN_VERSION}/main"; \
        echo "https://mirrors.aliyun.com/alpine/v${MAIN_VERSION}/community"; \
        echo '@edge https://mirrors.aliyun.com/alpine/edge/main'; \
        echo '@testing https://mirrors.aliyun.com/alpine/edge/testing'; \
        echo '@community https://mirrors.aliyun.com/alpine/edge/community'; \
    } >> /etc/apk/repositories \
    && apk add --update --no-cache bash \
    && { \
        echo '#!/bin/bash'; \
        echo 'set -e'; \
        echo 'EXEC="bin/cmak -Dconfig.file=$CONFIG_FILE_PATH -Dhttp.port=$BIND_HTTP_PORT -Dapplication.home=$PWD"'; \
        echo 'if [ ! -z "$@" ]; then EXEC="$@"; fi'; \
        echo 'exec $EXEC'; \
    } >> entrypoint.sh

ADD cmak-3.0.0.4/ .

EXPOSE 3000

ENV BIND_HTTP_PORT=3000 \
    CONFIG_FILE_PATH="conf/application.conf"

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
