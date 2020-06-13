FROM linuxserver/smokeping:amd64-latest

MAINTAINER Gianpaolo Del Matto "buildmaint@phunsites.net"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.0" \
    org.label-schema.description="This is a derivate of LinuxServer.io's smokeping, adding automatic service restart upon config file changes" \
    org.label-schema.name=smokeping \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/gpdm/smokeping/tree/master/smokeping

RUN mkdir -p /etc/services.d/nfs-changenotifier /etc/services.d/inotifyd
COPY files/usr/bin/nfs-changenotifier.sh /usr/bin/
COPY files/usr/bin/smokeping-restart.sh /usr/bin/
COPY files/etc/services.d/nfs-changenotifier/run /etc/services.d/nfs-changenotifier
COPY files/etc/services.d/inotifyd/run /etc/services.d/inotifyd

ENV SPMONITOR_VERBOSE=0
