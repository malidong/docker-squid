FROM alpine:latest

ARG VERSION=dev
ARG BUILD_DATE=""
ARG VCS_REF=""

LABEL maintainer="Stand-E Consulting <stand.e.consulting@gmail.com>" \
        org.opencontainers.image.created="$BUILD_DATE" \
        org.opencontainers.image.version="$VERSION" \
        org.opencontainers.image.revision="$VCS_REF" \
        org.opencontainers.image.authors="Stand-E Consulting <stand.e.consulting@gmail.com>" \
        org.opencontainers.image.title="Http proxy on Docker" \
        org.opencontainers.image.description="Docker image to run an squid server for http proxy." \
        org.opencontainers.image.url="https://github.com/malidong/docker-squid" \
        org.opencontainers.image.source="https://github.com/malidong/docker-squid" \
        org.opencontainers.image.documentation="https://github.com/malidong/docker-squid"

RUN apk add --no-cache squid tini

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh

VOLUME ["/etc/squid", "/var/cache/squid", "/var/log/squid"]
EXPOSE 3128/tcp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/src/run.sh"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD squid -k check || exit 1
