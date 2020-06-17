FROM alpine:3

RUN apk add --no-cache python2
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
ADD https://raw.githubusercontent.com/andrey-pohilko/registry-cli/master/registry.py /usr/local/bin/registry-cli.py
ADD https://raw.githubusercontent.com/andrey-pohilko/registry-cli/master/requirements-build.txt requirements-build.txt
RUN chmod a+x /usr/local/bin/registry-cli.py && pip install -r requirements-build.txt

COPY --from=registry:2 /bin/registry /usr/local/bin/registry
COPY --from=registry:2 /etc/docker/registry/config.yml /etc/docker/registry/config.yml

ENV DOCKER_REGISTRY_URL=""
ENV DOCKER_REGISTRY_USER_PASS=""
ENV CRON="0 5 * * *"
ENV LOG_LEVEL="8"
ENV KEEP_TAGS="latest"
ENV KEEP_RELEASES_NUM="10"
ENV KEEP_BY_HOURS="144"
ENV OPTS=""

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]
