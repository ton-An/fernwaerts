#!/usr/bin/env bash
set -euo pipefail

: "${KONG_DECLARATIVE_CONFIG:?required}"

mkdir -p "$(dirname "${KONG_DECLARATIVE_CONFIG}")"

# Render the vendored declarative config. The file contains literal $ENV
# placeholders consumed by Kong's DB-less mode.
envsubst < /home/kong/temp.yml > "${KONG_DECLARATIVE_CONFIG}"

exec /entrypoint.sh kong docker-start
