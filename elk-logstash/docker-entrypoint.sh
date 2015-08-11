#!/bin/bash

set -e

export JAVA_OPTS="-Djava.io.tmpdir=/var/lib/logstash -Des.config=/config-dir/elasticsearch.yml"

# Run original entry point script
/docker-entrypoint.sh $@
