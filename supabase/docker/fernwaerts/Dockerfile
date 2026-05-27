# syntax=docker/dockerfile:1.7
#
# Fernwaerts all-in-one backend image.
#
# Bundles GoTrue (auth), PostgREST, Edge Functions, PowerSync, postgres-meta,
# Studio, Logflare (analytics), Vector (log shipper), and Kong (API gateway)
# in a single container supervised by s6-overlay. The only external service is
# Postgres, defined alongside this in deploy/compose.yml.
#
# Build from the repo root:
#   docker build -f docker/fernwaerts/Dockerfile -t fernwaerts:dev .
#
# Runtime base is ubuntu:24.04 to match kong/kong:3.9.1's glibc 2.39. Lifting
# older-base binaries onto a newer glibc works; the reverse does not.

###############################################################################
# Source stages                                                               #
###############################################################################

# https://github.com/supabase/auth/blob/v2.186.0/Dockerfile
FROM supabase/gotrue:v2.186.0               AS src-auth

# https://github.com/PostgREST/postgrest/blob/v14.8/Dockerfile
FROM postgrest/postgrest:v14.8              AS src-rest

# https://github.com/supabase/edge-runtime/blob/v1.71.2/Dockerfile
FROM supabase/edge-runtime:v1.71.2          AS src-functions

# https://github.com/powersync-ja/powersync-service/blob/9ca82d7258623b03b9acdf0406200cc82c1c8648/service/Dockerfile
# (tag: @powersync/service-image@1.21.0)
FROM journeyapps/powersync-service:1.21.0   AS src-powersync

# https://github.com/supabase/postgres-meta/blob/v0.96.3/Dockerfile
FROM supabase/postgres-meta:v0.96.3         AS src-meta

# https://github.com/supabase/supabase/blob/5f6060197e9e7de016dc7a50c18fdffa65eff9a5/apps/studio/Dockerfile
# (image tag encodes the commit SHA: 2026.04.27-sha-5f6060197e9e7de016dc7a50c18fdffa65eff9a5)
FROM supabase/studio:2026.04.27-sha-5f6060197e9e7de016dc7a50c18fdffa65eff9a5 AS src-studio

# https://github.com/Logflare/logflare/blob/v1.36.1/Dockerfile
# (repo is Logflare/logflare, not supabase/logflare)
FROM supabase/logflare:1.36.1               AS src-analytics

# https://github.com/Kong/docker-kong/blob/3.9.1/Dockerfile.deb
# (kong/kong images are built from Kong/docker-kong; ubuntu-based = Dockerfile.deb)
FROM kong/kong:3.9.1                        AS src-kong

# https://github.com/vectordotdev/vector/blob/v0.53.0/distribution/docker/alpine/Dockerfile
# (Docker Hub org is timberio; source repo is vectordotdev/vector)
FROM timberio/vector:0.53.0-alpine          AS src-vector

###############################################################################
# Stage: migrator payload (supabase CLI + project files)                      #
###############################################################################
FROM debian:bookworm-slim AS migrator-build

# https://github.com/supabase/cli/releases/tag/v2.101.0
# Release archive contains two binaries: supabase and supabase-go.
# If a future version drops supabase-go, the tar below will fail loudly — check
# release assets before bumping.
ARG SUPABASE_CLI_VERSION=2.101.0
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends \
     ca-certificates curl \
     && rm -rf /var/lib/apt/lists/* \
     && curl -fsSL \
     "https://github.com/supabase/cli/releases/download/v${SUPABASE_CLI_VERSION}/supabase_${SUPABASE_CLI_VERSION}_linux_${TARGETARCH}.tar.gz" \
     | tar -C /usr/local/bin -xz supabase supabase-go

WORKDIR /payload
COPY supabase/schemas/              ./supabase/schemas/
COPY supabase/migrations/           ./supabase/migrations/
COPY supabase/functions/            ./supabase/functions/
COPY supabase/migration_config.toml ./supabase/config.toml
COPY supabase/supabase_vendor/db/init-scripts ./vendor/init-scripts
COPY supabase/supabase_vendor/db/migrations   ./vendor/migrations

###############################################################################
# Stage: runtime                                                              #
###############################################################################
FROM ubuntu:24.04

ARG S6_OVERLAY_VERSION=3.2.0.2
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
     S6_KEEP_ENV=1 \
     S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
     S6_CMD_WAIT_FOR_SERVICES_MAXTIME=120000 \
     S6_VERBOSITY=1

# ── s6-overlay v3.2.0.2 ──────────────────────────────────────────────────────
# https://github.com/just-containers/s6-overlay/releases/tag/v3.2.0.2
RUN apt-get update && apt-get install -y --no-install-recommends \
     ca-certificates curl xz-utils \
     && rm -rf /var/lib/apt/lists/* \
     && S6_ARCH=$([ "${TARGETARCH}" = "arm64" ] && echo "aarch64" || echo "x86_64") \
     && curl -fsSL \
     "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
     -o /tmp/s6-overlay-noarch.tar.xz \
     && curl -fsSL \
     "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
     -o "/tmp/s6-overlay-${S6_ARCH}.tar.xz" \
     && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
     && tar -C / -Jxpf "/tmp/s6-overlay-${S6_ARCH}.tar.xz" \
     && rm /tmp/s6-overlay-*.tar.xz
RUN apt-get purge -y curl xz-utils \
     && apt-get autoremove -y \
     && rm -rf /var/lib/apt/lists/*

# ── Node.js 24 ────────────────────────────────────────────────────────────────
# https://github.com/nodesource/distributions
RUN apt-get update && apt-get install -y --no-install-recommends \
     ca-certificates curl gnupg \
     && rm -rf /var/lib/apt/lists/* \
     && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
     && apt-get install -y --no-install-recommends nodejs
RUN apt-get purge -y curl gnupg \
     && apt-get autoremove -y \
     && rm -rf /var/lib/apt/lists/*

# ── Vector v0.53.0 ────────────────────────────────────────────────────────────
# https://github.com/vectordotdev/vector/blob/v0.53.0/distribution/docker/alpine/Dockerfile
COPY --from=src-vector /usr/local/bin/vector /usr/local/bin/vector
COPY docker/fernwaerts/vector.yml            /etc/vector/vector.yml

# ── GoTrue v2.186.0 (auth) ────────────────────────────────────────────────────
# https://github.com/supabase/auth/blob/v2.186.0/Dockerfile
COPY --from=src-auth /usr/local/bin/auth /opt/auth/auth

# ── PostgREST v14.8 (rest) ────────────────────────────────────────────────────
# https://github.com/PostgREST/postgrest/blob/v14.8/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
     libgmp10 libpq5 libssl3 zlib1g libnuma1 \
     && rm -rf /var/lib/apt/lists/*
COPY --from=src-rest /bin/postgrest /opt/rest/postgrest

# ── Edge Runtime v1.71.2 (functions) ──────────────────────────────────────────
# https://github.com/supabase/edge-runtime/blob/v1.71.2/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
     libblas3 liblapack3 libopenblas0-pthread \
     && rm -rf /var/lib/apt/lists/*
COPY --from=src-functions /usr/local/bin/edge-runtime /opt/functions/edge-runtime

# ── postgres-meta v0.96.3 (meta) ──────────────────────────────────────────────
# https://github.com/supabase/postgres-meta/blob/v0.96.3/Dockerfile
COPY --from=src-meta /usr/src/app /opt/meta/

# ── PowerSync v1.21.0 ─────────────────────────────────────────────────────────
# https://github.com/powersync-ja/powersync-service/blob/916cb924c54aeb7326cddea9468eb2d5be4fff72/service/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
     libyaml-0-2 \
     && rm -rf /var/lib/apt/lists/*
COPY --from=src-powersync /app /opt/powersync/
COPY supabase/powersync/config/powersync.yaml  /etc/powersync/powersync.yaml
COPY supabase/powersync/config/sync_rules.yaml /etc/powersync/sync_rules.yaml

# ── Studio 2026.04.27 / sha 5f6060197e9e7de016dc7a50c18fdffa65eff9a5 ──────────────────────────────────────────
# https://github.com/supabase/supabase/blob/5f6060197e9e7de016dc7a50c18fdffa65eff9a5/apps/studio/Dockerfile
COPY --from=src-studio /app /opt/studio/

# ── Logflare v1.36.1 (analytics) ──────────────────────────────────────────────
# https://github.com/Logflare/logflare/blob/v1.36.1/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
     locales libstdc++6 \
     && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
     && locale-gen \
     && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
COPY --from=src-analytics /opt/app /opt/analytics/
# Logflare's crypto NIF needs its own OpenSSL; isolated to avoid affecting other services.
COPY --from=src-analytics \
     /usr/lib/*-linux-gnu/libcrypto.so.3 \
     /usr/lib/*-linux-gnu/libssl.so.3 \
     /opt/analytics/openssl/

# ── Kong v3.9.1 ───────────────────────────────────────────────────────────────
# https://github.com/Kong/docker-kong/blob/3.9.1/Dockerfile.deb
RUN apt-get update && apt-get install -y --no-install-recommends \
     gettext-base \
     && rm -rf /var/lib/apt/lists/*
COPY --from=src-kong /usr/local/bin/kong     /usr/local/bin/kong
COPY --from=src-kong /usr/local/openresty    /usr/local/openresty
COPY --from=src-kong /usr/local/kong         /usr/local/kong
COPY --from=src-kong /usr/local/share/lua    /usr/local/share/lua
COPY --from=src-kong /usr/local/lib/lua      /usr/local/lib/lua
COPY --from=src-kong /usr/local/lib/luarocks /usr/local/lib/luarocks
COPY --from=src-kong /entrypoint.sh /entrypoint.sh
RUN mkdir -p /home/kong \
     && groupadd --system kong \
     && useradd --system --gid kong --no-create-home kong
COPY supabase/supabase_vendor/api/kong.yml           /home/kong/temp.yml
COPY supabase/supabase_vendor/api/kong-entrypoint.sh /home/kong/kong-entrypoint.sh
RUN chmod +x /home/kong/kong-entrypoint.sh /entrypoint.sh

# ── Supabase CLI v2.101.0 + migrate payload ───────────────────────────────────
# https://github.com/supabase/cli/releases/tag/v2.101.0
RUN apt-get update && apt-get install -y --no-install-recommends \
     postgresql-client \
     && rm -rf /var/lib/apt/lists/*
COPY --from=migrator-build /usr/local/bin/supabase    /usr/local/bin/supabase
COPY --from=migrator-build /usr/local/bin/supabase-go /usr/local/bin/supabase-go
COPY --from=migrator-build /payload                   /opt/migrate
COPY docker/fernwaerts/migrate/entrypoint.sh          /opt/migrate/entrypoint.sh
RUN mkdir -p /home/deno \
     && cp -a /opt/migrate/supabase/functions /home/deno/functions \
     && chmod +x /opt/migrate/entrypoint.sh

# ── s6 service definitions + log directories ──────────────────────────────────
COPY docker/fernwaerts/s6/ /etc/s6-overlay/s6-rc.d/
RUN set -eux; \
     for svc in auth rest functions powersync meta analytics studio kong vector init-migrator; do \
     mkdir -p "/var/log/${svc}"; \
     chmod 02750 "/var/log/${svc}"; \
     done

EXPOSE 8000 7901

ENTRYPOINT ["/init"]
