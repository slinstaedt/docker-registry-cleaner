# Cleanup job for docker registry
This job schedules itself via cron and periodically cleans up a local (=same host) docker registry via
- [registry-cli](https://github.com/andrey-pohilko/registry-cli)
- [registry garbage collect](https://docs.docker.com/registry/garbage-collection/)

## Requirements
- Cleaner only works for docker registry version 2
- Registry must have delete enabled (see [docker-compose.yml](docker-compose.yml))
- Mounting the docker registry's data volume (see [docker-compose.yml](docker-compose.yml))
- If custom registry data location is used, the location must also be configured for the cleaner

## Usage via docker
```
docker run -d -v<VOLUME_NAME>:/var/lib/registry kamalook/docker-registry-cleaner
```

## Usage via compose or swarm
Have a look at the supplied [docker-compose.yml](docker-compose.yml).
