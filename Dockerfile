FROM alpine:3.15
MAINTAINER Stand-E Consulting<stand.e.consulting@gmail.com>

RUN apk update && apk add squid --no-cache && rm -vrf /var/cache/apk/*

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh
VOLUME ["/etc/squid"]
EXPOSE 3128/tcp

CMD ["/opt/src/run.sh"]

LABEL maintainer="Stand-E Consulting<stand.e.consulting@gmail.com>" \
    org.opencontainers.image.created="$BUILD_DATE" \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.revision="$VCS_REF" \
    org.opencontainers.image.authors="Stand-E Consulting<stand.e.consulting@gmail.com>" \
    org.opencontainers.image.title="Http proxy on Docker" \
    org.opencontainers.image.description="Docker image to run an squid server for http proxy." \
    org.opencontainers.image.url="https://github.com/malidong/docker-squid" \
    org.opencontainers.image.source="https://github.com/malidong/docker-squid" \
    org.opencontainers.image.documentation="https://github.com/malidong/docker-squid"
