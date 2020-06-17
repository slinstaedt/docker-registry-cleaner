#!/bin/sh
set -euo pipefail

SCRIPT=/usr/local/bin/registry-cleanup.sh
cat > $SCRIPT << EOF
#!/bin/sh
set -euo pipefail

echo "=== Cleanup Releaes ==="
registry-cli.py $OPTS \
	${DOCKER_REGISTRY_USER_PASS:+-l $DOCKER_REGISTRY_USER_PASS} \
	-r ${DOCKER_REGISTRY_URL:?err} \
	-d --tags-like "^\d.+" -n $KEEP_RELEASES_NUM \
	${KEEP_BY_HOURS:+--keep-by-hours $KEEP_BY_HOURS} \
	${KEEP_TAGS:+--keep-tags $KEEP_TAGS}

echo "=== Cleanup Snapshots ==="
registry-cli.py $OPTS \
	${DOCKER_REGISTRY_USER_PASS:+-l $DOCKER_REGISTRY_USER_PASS} \
	-r ${DOCKER_REGISTRY_URL:?err} \
	-d --tags-like "^\D.+" -n 0 \
	${KEEP_BY_HOURS:+--keep-by-hours $KEEP_BY_HOURS} \
	${KEEP_TAGS:+--keep-tags $KEEP_TAGS}

echo "=== Garbage collect untagged images ==="
registry garbage-collect -m /etc/docker/registry/config.yml
EOF
chmod a+x $SCRIPT

CRONFILE=$(mktemp)
echo "$CRON $SCRIPT 2>&1" > $CRONFILE
crontab $CRONFILE
rm $CRONFILE

crond -f -l ${LOG_LEVEL:?err}
