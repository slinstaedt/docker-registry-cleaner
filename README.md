# Cleanup job for docker registry
This job schedules itself via cron and periodically cleans up a local (=same host) docker registry via
- [registry-cli](https://github.com/andrey-pohilko/registry-cli)
- [registry garbage collect](https://docs.docker.com/registry/garbage-collection/)

## Requirements
- Cleaner only works for docker registry version 2
- Registry must have delete enabled (see [docker-compose.yml](docker-compose.yml))
- Mounting the docker registry's data volume (see [docker-compose.yml](docker-compose.yml))
- If custom registry data location is used, the location must also be configured for the cleaner

## Configuration
The following environment variables are used:
| Name                      | default   | Description                                                    |
|---------------------------|-----------|----------------------------------------------------------------|
| DOCKER_REGISTRY_URL       |           | URL of the docker registry (required)                          |
| DOCKER_REGISTRY_USER_PASS |           | "username:password" of docker registry, if it's protected      |
| CRON                      | 0 5 * * * | Cron expression to schedule cleanup, defaults to 5am every day |
| LOG_LEVEL                 | 8         | Log level for cron process                                     |
| KEEP_TAGS                 | latest    | Tags to exclude from deletion (separated by spaces)            |
| KEEP_RELEASES_NUM         | 10        | Number of releases to keep                                     |
| KEEP_BY_HOURS             | 144       | Tags younger than the given hours wont be deleted at all       |
| OPTS                      |           | Additional arguments for registry-cli                          |

## Usage via docker
```
docker run -d -v<VOLUME_NAME>:/var/lib/registry kamalook/docker-registry-cleaner
```

## Usage via compose or swarm
Have a look at the supplied [docker-compose.yml](docker-compose.yml).
