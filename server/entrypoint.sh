#!/bin/bash

set -eu -o pipefail

echo "Render entrypoint.."
export BIND_ON_IP="${BIND_ON_IP:-$(hostname -i)}"
if [[ -z "${TEMPORAL_CLI_ADDRESS:-}" ]]; then
  if [[ "${BIND_ON_IP}" =~ ":" ]]; then
      # ipv6
      export TEMPORAL_CLI_ADDRESS="[${BIND_ON_IP}]:7233"
  else
      # ipv4
      export TEMPORAL_CLI_ADDRESS="${BIND_ON_IP}:7233"
  fi
fi
echo "TEMPORAL_CLI_ADDRESS=${TEMPORAL_CLI_ADDRESS}"


dockerize -template /etc/temporal/config/config_template.yaml:/etc/temporal/config/docker.yaml

exec /etc/temporal/start-temporal.sh
