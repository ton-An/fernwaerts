#!/usr/bin/env bash
# Build-time/runtime sanity check for the all-in-one Fernwaerts backend image.
#
# Default usage:
#   supabase/docker/fernwaerts/verify-runtime.sh
#
# Optional compose smoke test:
#   VERIFY_COMPOSE=1 supabase/docker/fernwaerts/verify-runtime.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
IMAGE_OWNER="${FERNWAERTS_IMAGE_OWNER:-fernwaerts}"
IMAGE_VERSION="${FERNWAERTS_VERSION:-verify}"
BACKEND_IMAGE="ghcr.io/${IMAGE_OWNER}/fernwaerts:${IMAGE_VERSION}"
POSTGRES_IMAGE="ghcr.io/${IMAGE_OWNER}/fernwaerts-postgres:${IMAGE_VERSION}"
COMPOSE_PROJECT="${VERIFY_COMPOSE_PROJECT:-fernwaerts-verify}"
DEPLOY_ENV="${DEPLOY_ENV:-${ROOT_DIR}/supabase/deploy/.env}"
API_PORT="${VERIFY_API_PORT:-18000}"
POWERSYNC_PORT="${VERIFY_POWERSYNC_PORT:-17901}"

log() {
  printf '[verify-runtime] %s\n' "$*"
}

log "building ${BACKEND_IMAGE}"
docker build -f "${ROOT_DIR}/supabase/docker/fernwaerts/Dockerfile" -t "${BACKEND_IMAGE}" "${ROOT_DIR}"

log "checking runtime commands and shared libraries"
docker run --rm --entrypoint /bin/bash "${BACKEND_IMAGE}" -lc '
set -euo pipefail
export PATH=/usr/local/openresty/bin:${PATH}

for cmd in pg_isready psql envsubst node erl vector kong; do
  command -v "${cmd}" >/dev/null
done

node --version
erl -noshell -eval "erlang:halt()."
vector --version
kong version

for bin in \
  /opt/auth/auth \
  /opt/rest/postgrest \
  /opt/functions/edge-runtime \
  /usr/local/bin/vector \
  /usr/local/bin/kong
do
  printf "\nldd %s\n" "${bin}"
  output="$(ldd "${bin}" 2>&1 || true)"
  printf "%s\n" "${output}"
  if printf "%s\n" "${output}" | grep -q "not found"; then
    exit 1
  fi
done
'

log "checking for unused apt packages (informational)"
docker run --rm --entrypoint /bin/bash "${BACKEND_IMAGE}" -lc '
set -euo pipefail
export PATH=/usr/local/openresty/bin:${PATH}

# Packages explicitly installed in the Dockerfile (non-Erlang). Keep in sync
# with the RUN apt-get install blocks in supabase/docker/fernwaerts/Dockerfile.
# Erlang packages are omitted: the BEAM VM loads modules dynamically, so ldd
# cannot see those references. They are verified by the erl smoke-test above.
DOCKERFILE_PKGS="
  ca-certificates
  curl
  xz-utils
  gnupg
  postgresql-client
  gettext-base
  libssl3
  libffi8
  libgmp10
  libpq5
  libyaml-0-2
  nodejs
"

# Run ldd on a file, tolerating failure (static/non-ELF files exit non-zero).
safe_ldd() { ldd "$1" 2>/dev/null || true; }

# Collect .so paths linked by the service binaries and native Node addons.
collect_libs() {
  for bin in \
    /opt/auth/auth \
    /opt/rest/postgrest \
    /opt/functions/edge-runtime \
    /usr/local/bin/vector \
    /usr/local/bin/kong \
    "$(command -v node 2>/dev/null || true)" \
    "$(command -v erl  2>/dev/null || true)"
  do
    [ -f "${bin}" ] && safe_ldd "${bin}"
  done
  while IFS= read -r f; do
    safe_ldd "${f}"
  done < <(find /opt/powersync /opt/meta /opt/studio -name "*.node" 2>/dev/null)
}

# Normalize /lib/ -> /usr/lib/ (Ubuntu 24.04 merged /lib as a symlink to usr/lib;
# ldd returns /lib paths but dpkg tracks files under /usr/lib).
needed_libs=$(collect_libs | awk "/=>/ {print \$3}" | grep -v "^$" \
  | sed "s|^/lib/|/usr/lib/|" | sort -u)

unused=()
for pkg in ${DOCKERFILE_PKGS}; do
  # dpkg -l supports glob matching; "pkg*" finds meta-packages, t64 renames, and
  # versioned variants (e.g. postgresql-client -> postgresql-client-16, -common).
  # Iterate all matching packages so meta-packages (which have no files themselves)
  # do not mask the binaries that live in their versioned sub-packages.
  actual_pkgs=$(dpkg -l "${pkg}*" 2>/dev/null | awk "/^ii/ {print \$2}")
  if [ -z "${actual_pkgs}" ]; then
    unused+=("${pkg} [not installed?]")
    continue
  fi

  is_needed=0
  while IFS= read -r actual && [ "${is_needed}" -eq 0 ]; do
    # Check if any .so file from this package is dynamically linked by a service binary.
    while IFS= read -r f; do
      [ -n "${f}" ] || continue
      if printf "%s\n" "${needed_libs}" | grep -qxF "${f}"; then
        is_needed=1; break
      fi
    done < <(dpkg --listfiles "${actual}" 2>/dev/null | grep -E "\.so" || true)

    # Check if any binary from this package is referenced in startup scripts.
    # /home/kong/kong-entrypoint.sh is called by the Kong s6 service and uses envsubst.
    if [ "${is_needed}" -eq 0 ]; then
      while IFS= read -r f; do
        [ -n "${f}" ] || continue
        cmd=$(basename "${f}")
        if grep -rqE "(^|[[:space:]]|/)${cmd}([[:space:]]|\$)" \
            /etc/s6-overlay/s6-rc.d/ /opt/migrate/entrypoint.sh /home/kong/ 2>/dev/null; then
          is_needed=1; break
        fi
      done < <(dpkg --listfiles "${actual}" 2>/dev/null \
                 | grep -E "^/usr/(s?bin|local/bin)/[^/]+\$" || true)
    fi
  done <<< "${actual_pkgs}"

  [ "${is_needed}" -eq 0 ] && unused+=("${pkg}")
done

if [ "${#unused[@]}" -gt 0 ]; then
  printf "[warn] potentially unused at runtime (build-time only or unneeded):\n"
  printf "  %s\n" "${unused[@]}"
else
  printf "no unused packages detected\n"
fi
'

if [[ "${VERIFY_COMPOSE:-0}" != "1" ]]; then
  log "skipping compose smoke test; set VERIFY_COMPOSE=1 to run it"
  exit 0
fi

if [[ ! -f "${DEPLOY_ENV}" ]]; then
  log "compose smoke test requires ${DEPLOY_ENV}"
  exit 1
fi

log "building ${POSTGRES_IMAGE}"
docker build -f "${ROOT_DIR}/supabase/docker/fernwaerts-postgres/Dockerfile" -t "${POSTGRES_IMAGE}" "${ROOT_DIR}"

cleanup() {
  log "stopping compose project ${COMPOSE_PROJECT}"
  (
    cd "${ROOT_DIR}/supabase/deploy"
    FERNWAERTS_IMAGE_OWNER="${IMAGE_OWNER}" FERNWAERTS_VERSION="${IMAGE_VERSION}" \
      API_PORT="${API_PORT}" POWERSYNC_PORT="${POWERSYNC_PORT}" \
      docker compose --env-file "${DEPLOY_ENV}" -p "${COMPOSE_PROJECT}" down -v
  )
}
trap cleanup EXIT

log "starting compose project ${COMPOSE_PROJECT} on ${API_PORT}:8000 and ${POWERSYNC_PORT}:7901"
(
  cd "${ROOT_DIR}/deploy"
  FERNWAERTS_IMAGE_OWNER="${IMAGE_OWNER}" FERNWAERTS_VERSION="${IMAGE_VERSION}" \
    API_PORT="${API_PORT}" POWERSYNC_PORT="${POWERSYNC_PORT}" \
    docker compose --env-file "${DEPLOY_ENV}" -p "${COMPOSE_PROJECT}" up -d
)

log "waiting for backend startup"
sleep "${VERIFY_STARTUP_SECONDS:-45}"

log "checking compose services"
(
  cd "${ROOT_DIR}/deploy"
  FERNWAERTS_IMAGE_OWNER="${IMAGE_OWNER}" FERNWAERTS_VERSION="${IMAGE_VERSION}" \
    API_PORT="${API_PORT}" POWERSYNC_PORT="${POWERSYNC_PORT}" \
    docker compose --env-file "${DEPLOY_ENV}" -p "${COMPOSE_PROJECT}" ps
  logs="$(
    FERNWAERTS_IMAGE_OWNER="${IMAGE_OWNER}" FERNWAERTS_VERSION="${IMAGE_VERSION}" \
      API_PORT="${API_PORT}" POWERSYNC_PORT="${POWERSYNC_PORT}" \
      docker compose --env-file "${DEPLOY_ENV}" -p "${COMPOSE_PROJECT}" logs --no-color --tail=200 fernwaerts
  )"
  printf "%s\n" "${logs}"
  if printf "%s\n" "${logs}" | grep -qi "fatal:"; then
    log "fatal backend log line detected"
    exit 1
  fi
  FERNWAERTS_IMAGE_OWNER="${IMAGE_OWNER}" FERNWAERTS_VERSION="${IMAGE_VERSION}" \
    API_PORT="${API_PORT}" POWERSYNC_PORT="${POWERSYNC_PORT}" \
    docker compose --env-file "${DEPLOY_ENV}" -p "${COMPOSE_PROJECT}" exec -T fernwaerts /command/s6-rc -a list
)
