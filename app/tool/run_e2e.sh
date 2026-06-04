#!/usr/bin/env bash
# Orchestrates the Flutter e2e auth suite against a real Docker backend.
#
# Brings up `fernwaerts` + `fernwaerts-postgres` + `mailpit` from
# `supabase/deploy/compose.yml` + `compose.e2e.yml`, waits until both the
# backend API and Mailpit are healthy, runs `integration_test/e2e_test.dart`,
# then tears the stack down on exit.
#
# Usage (run from anywhere):
#     app/tool/run_e2e.sh --platform android -d emulator-5554
#     app/tool/run_e2e.sh --platform ios -d <simulator-id>
#     KEEP_STACK=1 app/tool/run_e2e.sh            # leave the backend running
#     FERNWAERTS_VERSION=dev ...                  # use a locally built image
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

TARGET_PLATFORM=""
DEVICE_ID=""
FLUTTER_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      if [[ -z "${2:-}" ]]; then
        echo "[e2e] --platform requires a value" >&2
        exit 64
      fi
      TARGET_PLATFORM="$2"
      shift 2
      ;;
    --platform=*)
      TARGET_PLATFORM="${1#*=}"
      shift
      ;;
    -d|--device-id)
      if [[ -z "${2:-}" ]]; then
        echo "[e2e] $1 requires a value" >&2
        exit 64
      fi
      DEVICE_ID="$2"
      FLUTTER_ARGS+=("$1" "$2")
      shift 2
      ;;
    --device-id=*)
      DEVICE_ID="${1#*=}"
      FLUTTER_ARGS+=("$1")
      shift
      ;;
    *)
      FLUTTER_ARGS+=("$1")
      shift
      ;;
  esac
done

TARGET_PLATFORM="$(printf '%s' "$TARGET_PLATFORM" | tr '[:upper:]' '[:lower:]')"
if [[ -z "$TARGET_PLATFORM" ]]; then
  echo "[e2e] --platform is required" >&2
  echo "[e2e] expected one of: android, ios" >&2
  exit 64
fi

case "$TARGET_PLATFORM" in
  android|ios) ;;
  *)
    echo "[e2e] unsupported platform: $TARGET_PLATFORM" >&2
    echo "[e2e] expected one of: android, ios" >&2
    exit 64
    ;;
esac

if [[ "$TARGET_PLATFORM" == "android" && -z "$DEVICE_ID" ]]; then
  DEVICE_ID="$(
    adb devices | awk 'NR > 1 && $2 == "device" { print $1; exit }'
  )"
  if [[ -z "$DEVICE_ID" ]]; then
    echo "[e2e] no Android emulator device found" >&2
    adb devices >&2
    exit 1
  fi
  FLUTTER_ARGS+=("-d" "$DEVICE_ID")
fi

has_dart_define() {
  local key="$1"
  local index
  for index in "${!FLUTTER_ARGS[@]}"; do
    local arg="${FLUTTER_ARGS[$index]}"
    if [[ "$arg" == "--dart-define=$key="* || "$arg" == "-D$key="* ]]; then
      return 0
    fi
    if [[ "$arg" == "--dart-define" || "$arg" == "-D" ]]; then
      local next_index=$((index + 1))
      if [[ "${FLUTTER_ARGS[$next_index]:-}" == "$key="* ]]; then
        return 0
      fi
    fi
  done
  return 1
}

if [[ "$TARGET_PLATFORM" == "android" ]]; then
  DEFAULT_SERVER_URL="http://10.0.2.2:8000"
  DEFAULT_MAILPIT_URL="http://10.0.2.2:8025"
  DEFAULT_API_EXTERNAL_URL="http://10.0.2.2:8000"
  DEFAULT_POWERSYNC_EXTERNAL_URL="http://10.0.2.2:7901"
else
  DEFAULT_SERVER_URL="http://127.0.0.1:8000"
  DEFAULT_MAILPIT_URL="http://127.0.0.1:8025"
  DEFAULT_API_EXTERNAL_URL="http://localhost:8000"
  DEFAULT_POWERSYNC_EXTERNAL_URL="http://localhost:7901"
fi
if [[ "$TARGET_PLATFORM" == "android" ]]; then
  case "${API_EXTERNAL_URL:-}" in
    ""|"http://localhost:8000"|"http://127.0.0.1:8000")
      export API_EXTERNAL_URL="$DEFAULT_API_EXTERNAL_URL"
      ;;
  esac
  case "${SUPABASE_PUBLIC_URL:-}" in
    ""|"http://localhost:8000"|"http://127.0.0.1:8000")
      export SUPABASE_PUBLIC_URL="$DEFAULT_API_EXTERNAL_URL"
      ;;
  esac
  case "${POWERSYNC_EXTERNAL_URL:-}" in
    ""|"http://localhost:7901"|"http://127.0.0.1:7901")
      export POWERSYNC_EXTERNAL_URL="$DEFAULT_POWERSYNC_EXTERNAL_URL"
      ;;
  esac
else
  export API_EXTERNAL_URL="${API_EXTERNAL_URL:-$DEFAULT_API_EXTERNAL_URL}"
  export SUPABASE_PUBLIC_URL="${SUPABASE_PUBLIC_URL:-$DEFAULT_API_EXTERNAL_URL}"
  export POWERSYNC_EXTERNAL_URL="${POWERSYNC_EXTERNAL_URL:-$DEFAULT_POWERSYNC_EXTERNAL_URL}"
fi
echo "[e2e] advertising API at $API_EXTERNAL_URL"
echo "[e2e] advertising PowerSync at $POWERSYNC_EXTERNAL_URL"

ANDROID_PACKAGE_ID="${ANDROID_PACKAGE_ID:-eu.antons_webfabrik.location_history.dev}"

grant_android_permissions() {
  local device_id="$1"
  for permission in \
    android.permission.ACCESS_COARSE_LOCATION \
    android.permission.ACCESS_FINE_LOCATION \
    android.permission.ACCESS_BACKGROUND_LOCATION \
    android.permission.ACTIVITY_RECOGNITION \
    android.permission.POST_NOTIFICATIONS; do
    adb -s "$device_id" shell pm grant "$ANDROID_PACKAGE_ID" "$permission" \
      >/dev/null 2>&1 || true
  done
}

if ! has_dart_define E2E_SERVER_URL; then
  FLUTTER_ARGS+=(
    "--dart-define=E2E_SERVER_URL=${E2E_SERVER_URL:-$DEFAULT_SERVER_URL}"
  )
fi
if ! has_dart_define E2E_MAILPIT_URL; then
  FLUTTER_ARGS+=(
    "--dart-define=E2E_MAILPIT_URL=${E2E_MAILPIT_URL:-$DEFAULT_MAILPIT_URL}"
  )
fi

cleanup() {
  if [[ -n "${PERMISSION_WATCHER_PID:-}" ]]; then
    kill "$PERMISSION_WATCHER_PID" >/dev/null 2>&1 || true
  fi
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

echo "[e2e] running flutter integration test on $TARGET_PLATFORM..."

cd "$APP_DIR"

if [[ "$TARGET_PLATFORM" == "ios" && -n "$DEVICE_ID" ]]; then
  IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-eu.antons-webfabrik.location-history.dev}"
  flutter build ios --simulator --debug --flavor "${FLAVOR:-Development}"
  APP_BUNDLE_PATH="$APP_DIR/build/ios/iphonesimulator/Runner.app"
  if [[ ! -d "$APP_BUNDLE_PATH" ]]; then
    echo "[e2e] expected simulator app bundle not found: $APP_BUNDLE_PATH" >&2
    exit 1
  fi
  xcrun simctl install "$DEVICE_ID" "$APP_BUNDLE_PATH"
  for svc in location location-always motion; do
    xcrun simctl privacy "$DEVICE_ID" grant "$svc" "$IOS_BUNDLE_ID" \
      >/dev/null 2>&1 || true
  done
  echo "[e2e] iOS permissions pre-granted to $IOS_BUNDLE_ID" >&2
fi

if [[ "$TARGET_PLATFORM" == "android" && -n "$DEVICE_ID" ]]; then
  ANDROID_FLAVOR="${FLAVOR:-development}"
  flutter build apk --debug --flavor "$ANDROID_FLAVOR"
  APK_PATH="$APP_DIR/build/app/outputs/flutter-apk/app-$ANDROID_FLAVOR-debug.apk"
  if [[ ! -f "$APK_PATH" ]]; then
    echo "[e2e] expected Android APK not found: $APK_PATH" >&2
    exit 1
  fi
  adb -s "$DEVICE_ID" install -r "$APK_PATH" >/dev/null
  grant_android_permissions "$DEVICE_ID"
  echo "[e2e] Android permissions pre-granted to $ANDROID_PACKAGE_ID" >&2
fi

TEST_COMMAND=(flutter test)
if [[ "$TARGET_PLATFORM" == "ios" ]]; then
  TEST_COMMAND+=(--flavor "${FLAVOR:-Development}")
elif [[ "$TARGET_PLATFORM" == "android" ]]; then
  TEST_COMMAND+=(--flavor "${FLAVOR:-development}")
fi
TEST_COMMAND+=(integration_test/e2e_test.dart)

if [[ "$TARGET_PLATFORM" == "android" && -n "$DEVICE_ID" ]]; then
  (
    deadline=$(( $(date +%s) + 90 ))
    while (( $(date +%s) < deadline )); do
      grant_android_permissions "$DEVICE_ID"
      sleep 1
    done
  ) &
  PERMISSION_WATCHER_PID=$!
fi

"${TEST_COMMAND[@]}" "${FLUTTER_ARGS[@]}"
