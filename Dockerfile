FROM alpine:latest
RUN apk update && apk upgrade && apk add --no-cache openjdk8-jre tomcat-native sqlite-libs redis && ln /usr/lib/libsqlite3.so.0.* /usr/lib/libsqlite3.so && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
