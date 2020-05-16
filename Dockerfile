FROM mono:latest

LABEL maintainer="skyleiger"

RUN apt-get update && apt-get -y upgrade && apt-get -y install curl jq tzdata nano dos2unix

RUN addgroup --gid 1000 vintagestory \
  && useradd -s /bin/false -u 1000 -g vintagestory -d /home/vintagestory --create-home vintagestory \
  && mkdir -m 777 /data \
  && chown vintagestory:vintagestory /data /home/vintagestory

ADD https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.amd64 /usr/local/bin/su-exec
RUN chmod +x /usr/local/bin/su-exec

VOLUME ["/data"]
COPY serverconfig.json /tmp/serverconfig.json
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 SERVER_NAME="VintageStory-Server" SERVER_PORT=42420

COPY start* /
RUN dos2unix /start* && chmod +x /start*
