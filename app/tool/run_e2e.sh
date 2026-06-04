#!/usr/bin/env bash
# Orchestrates the Flutter e2e auth suite against a real Docker backend.
#
# Brings up `fernwaerts` + `fernwaerts-postgres` + `mailpit` from
# `supabase/deploy/compose.yml` + `compose.e2e.yml`, waits until both the
# backend API and Mailpit are healthy, runs `integration_test/e2e_test.dart`,
# then tears the stack down on exit.
#
# Usage (run from anywhere):
#     app/tool/run_e2e.sh                  # default device
#     app/tool/run_e2e.sh -d <device-id>   # pin a specific device
#     KEEP_STACK=1 app/tool/run_e2e.sh     # leave the backend running after
#     FERNWAERTS_VERSION=dev …             # use a locally built bundle image
#
# The Supabase config below is a self-contained test fixture: deterministic
# secrets so the JWTs verify, all bound to localhost. It is not appropriate
# for any real deployment.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$APP_DIR/.." && pwd)"
DEPLOY_DIR="$REPO_ROOT/supabase/deploy"

# --- backend configuration ------------------------------------------------
# Pinned demo JWT_SECRET — the ANON_KEY/SERVICE_ROLE_KEY below are the
# standard Supabase self-hosting demo JWTs signed with this secret. They
# expire in 2032. Override any of these via the environment if needed.
export FERNWAERTS_VERSION="${FERNWAERTS_VERSION:-latest}"
export FERNWAERTS_IMAGE_OWNER="${FERNWAERTS_IMAGE_OWNER:-ton-an}"

export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-fernwaerts-e2e-postgres}"
export JWT_SECRET="${JWT_SECRET:-super-secret-jwt-token-with-at-least-32-characters-long}"
export ANON_KEY="${ANON_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0}"
export SERVICE_ROLE_KEY="${SERVICE_ROLE_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU}"
export PS_SOURCE_PASSWORD="${PS_SOURCE_PASSWORD:-fernwaerts-e2e-ps-source}"
export PS_STORAGE_PASSWORD="${PS_STORAGE_PASSWORD:-fernwaerts-e2e-ps-storage}"
export DASHBOARD_USERNAME="${DASHBOARD_USERNAME:-fernwaerts}"
export DASHBOARD_PASSWORD="${DASHBOARD_PASSWORD:-fernwaerts-e2e-dashboard}"

cd "$DEPLOY_DIR"

COMPOSE=(docker compose -f compose.yml -f compose.e2e.yml)

cleanup() {
  if [[ "${KEEP_STACK:-0}" == "1" ]]; then
    echo "[e2e] KEEP_STACK=1 — leaving backend running on http://localhost:8000" >&2
    return
  fi
  echo "[e2e] tearing down docker stack..." >&2
  "${COMPOSE[@]}" down -v --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

echo "[e2e] resetting docker stack..."
"${COMPOSE[@]}" down -v --remove-orphans >/dev/null 2>&1 || true
"${COMPOSE[@]}" up -d

echo "[e2e] waiting for fernwaerts API..."
# /functions/v1/get_anon_key is the only HTTP entry point Kong exposes without
# an apikey header, so it's the cheapest authenticated-stack readiness probe.
deadline=$(( $(date +%s) + 180 ))
while ! curl -fsS "http://localhost:8000/functions/v1/get_anon_key" >/dev/null 2>&1; do
  if (( $(date +%s) >= deadline )); then
    echo "[e2e] fernwaerts API never came up; recent logs:" >&2
    "${COMPOSE[@]}" logs --tail=200 fernwaerts >&2 || true
    exit 1
  fi
  sleep 2
done

echo "[e2e] waiting for mailpit..."
deadline=$(( $(date +%s) + 60 ))
while ! curl -fsS "http://localhost:8025/readyz" >/dev/null 2>&1; do
  if (( $(date +%s) >= deadline )); then
    echo "[e2e] mailpit never came up" >&2
    exit 1
  fi
  sleep 1
done

echo "[e2e] running flutter integration test..."

BUNDLE_ID="${BUNDLE_ID:-eu.antons-webfabrik.location-history.dev}"
SIM_ID=""
for ((i=1; i<=$#; i++)); do
  if [[ "${!i}" == "-d" ]]; then
    j=$((i+1)); SIM_ID="${!j}"; break
  fi
done

cd "$APP_DIR"

if [[ -n "$SIM_ID" ]]; then
  flutter build ios --simulator --debug --flavor "${FLAVOR:-Development}"
  APP_BUNDLE_PATH="$APP_DIR/build/ios/iphonesimulator/Runner.app"
  if [[ ! -d "$APP_BUNDLE_PATH" ]]; then
    echo "[e2e] expected simulator app bundle not found: $APP_BUNDLE_PATH" >&2
    exit 1
  fi
  xcrun simctl install "$SIM_ID" "$APP_BUNDLE_PATH"
  for svc in location location-always motion; do
    xcrun simctl privacy "$SIM_ID" grant "$svc" "$BUNDLE_ID" \
      >/dev/null 2>&1 || true
  done
  echo "[e2e] iOS permissions pre-granted to $BUNDLE_ID" >&2
fi

flutter test --flavor "${FLAVOR:-Development}" integration_test/e2e_test.dart "$@"
