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
# Some upstream images ship on alpine/musl, others on debian or ubuntu. The
# runtime stage is ubuntu:24.04 (matching Kong's base) so glibc-linked
# binaries from older debian/ubuntu sources lift cleanly via COPY --from.
# Statically linked Go/Rust binaries (GoTrue, edge-runtime) work regardless.
# The BEAM release for Logflare runs against the system Erlang we install
# below rather than its embedded erts.

###############################################################################
# Stage: upstream binaries we lift directly                                   #
###############################################################################
FROM supabase/gotrue:v2.186.0               AS src-auth
FROM postgrest/postgrest:v14.8              AS src-rest
FROM supabase/edge-runtime:v1.71.2          AS src-functions
FROM journeyapps/powersync-service:1.21.0   AS src-powersync
FROM supabase/postgres-meta:v0.96.3         AS src-meta
FROM supabase/studio:2026.04.27-sha-5f60601 AS src-studio
FROM supabase/logflare:1.36.1               AS src-analytics
FROM kong/kong:3.9.1                        AS src-kong

###############################################################################
# Stage: migrator payload (supabase CLI + project files)                      #
###############################################################################
FROM debian:bookworm-slim AS migrator-build

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
#
# Base = ubuntu:24.04 (noble) to match kong/kong:3.9.1's glibc 2.39. Other
# upstream images use older bases (debian bookworm, alpine, distroless) and
# lift fine onto a newer glibc — newer libc is backward compatible. The
# reverse (lifting noble binaries onto bookworm) breaks with missing GLIBC
# symbol errors, which is why we don't base on bookworm.
FROM ubuntu:24.04

ARG S6_OVERLAY_VERSION=3.2.0.2
ARG VECTOR_VERSION=0.53.0
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
    S6_KEEP_ENV=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=120000 \
    S6_VERBOSITY=1

# Base OS deps shared by multiple services.
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl wget xz-utils gnupg \
      libssl3 libffi8 libgmp10 libpq5 \
      postgresql-client gettext-base libyaml-0-2 \
      tini procps \
 && rm -rf /var/lib/apt/lists/*

# Node 24 — needed by postgres-meta, Studio, PowerSync.
# PowerSync 1.20+ uses the 'using' TC39 syntax which requires Node 22+.
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

# Erlang/OTP — needed by Logflare BEAM release. Ubuntu noble ships Erlang 25;
# Logflare 1.36.x is compatible with 25+. If a future release requires 26,
# install from Erlang Solutions instead of the ubuntu archive.
RUN apt-get update && apt-get install -y --no-install-recommends \
      erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
      erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
      erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools \
      erlang-tftp erlang-tools erlang-xmerl \
 && rm -rf /var/lib/apt/lists/*

# Vector from official tarball. Map Docker's TARGETARCH to Vector's arch triplet.
RUN VECTOR_ARCH=$([ "${TARGETARCH}" = "arm64" ] && echo "aarch64" || echo "x86_64") \
 && curl -fsSL \
      "https://packages.timber.io/vector/${VECTOR_VERSION}/vector-${VECTOR_VERSION}-${VECTOR_ARCH}-unknown-linux-gnu.tar.gz" \
    | tar -xz -C /tmp \
 && mv "/tmp/vector-${VECTOR_ARCH}-unknown-linux-gnu/bin/vector" /usr/local/bin/vector \
 && rm -rf /tmp/vector-*

# s6-overlay.
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz  /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
 && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz \
 && rm /tmp/s6-overlay-*.tar.xz

# Service binaries / runtime trees lifted from upstream images.
#
# GoTrue, PostgREST, edge-runtime are single static binaries.
COPY --from=src-auth      /usr/local/bin/auth          /opt/auth/auth
COPY --from=src-rest      /bin/postgrest               /opt/rest/postgrest
COPY --from=src-functions /usr/local/bin/edge-runtime  /opt/functions/edge-runtime

# Node services — copy their /app trees, run with our system node.
COPY --from=src-meta      /usr/src/app                 /opt/meta/
COPY --from=src-powersync /app                         /opt/powersync/
COPY --from=src-studio    /app                         /opt/studio/

# Logflare BEAM release — embedded erts won't run on debian glibc; we use our
# system Erlang against the release's compiled .beam files.
COPY --from=src-analytics /opt/app /opt/analytics/
# Logflare's crypto NIF is compiled against OpenSSL 3.4+, newer than Ubuntu 24.04's
# 3.0.x. Copy the library from the logflare image so the NIF can load.
RUN --mount=type=bind,from=src-analytics,source=/usr/lib,target=/logflare-lib \
    LIBDIR=$([ "${TARGETARCH}" = "arm64" ] && echo "aarch64-linux-gnu" || echo "x86_64-linux-gnu") ; \
    mkdir -p /opt/analytics/openssl ; \
    cp /logflare-lib/${LIBDIR}/libcrypto.so.3 /opt/analytics/openssl/ ; \
    cp /logflare-lib/${LIBDIR}/libssl.so.3 /opt/analytics/openssl/

# Kong = openresty (nginx + lua) + kong's lua modules. Image base is also
# ubuntu:24.04, so all libc-linked binaries match ours. Defaults under
# /etc/kong are unused at runtime — every Kong setting is passed via KONG_*
# env vars from the s6 run script, so we don't lift /etc/kong itself; our own
# kong.yml lands there in a later COPY.
COPY --from=src-kong /usr/local/bin/kong     /usr/local/bin/kong
COPY --from=src-kong /usr/local/openresty    /usr/local/openresty
COPY --from=src-kong /usr/local/kong         /usr/local/kong
COPY --from=src-kong /usr/local/share/lua    /usr/local/share/lua
COPY --from=src-kong /usr/local/lib/lua      /usr/local/lib/lua
COPY --from=src-kong /usr/local/lib/luarocks /usr/local/lib/luarocks
# Upstream's docker entrypoint and the Supabase kong-entrypoint wrapper. The
# wrapper expects the unrendered kong.yml at /home/kong/temp.yml and writes
# the rendered copy to KONG_DECLARATIVE_CONFIG.
COPY --from=src-kong /entrypoint.sh          /entrypoint.sh
RUN mkdir -p /home/kong
# Kong's wrapper script may try to drop privileges to the `kong` user. Create
# it so that doesn't error even when we run everything as root under s6.
RUN groupadd --system kong && useradd --system --gid kong --no-create-home kong

# Migrator payload + supabase CLI.
COPY --from=migrator-build /usr/local/bin/supabase /usr/local/bin/supabase
COPY --from=migrator-build /usr/local/bin/supabase-go /usr/local/bin/supabase-go
COPY --from=migrator-build /payload                /opt/migrate
COPY docker/fernwaerts/migrate/entrypoint.sh      /opt/migrate/entrypoint.sh
RUN mkdir -p /home/deno \
 && cp -a /opt/migrate/supabase/functions /home/deno/functions \
 && chmod +x /opt/migrate/entrypoint.sh

# PowerSync runtime config.
COPY supabase/powersync/config/powersync.yaml /etc/powersync/powersync.yaml
COPY supabase/powersync/config/sync_rules.yaml /etc/powersync/sync_rules.yaml

# Vendored Supabase configs. Keep these in sync with the Supabase docker
# version documented in VERSIONS; builds must not depend on mutable GitHub
# refs or network-fetched config files.
COPY supabase/supabase_vendor/api/kong.yml            /home/kong/temp.yml
COPY supabase/supabase_vendor/api/kong-entrypoint.sh  /home/kong/kong-entrypoint.sh
COPY supabase/supabase_vendor/logs/vector.yml         /tmp/upstream-vector.yml

# vector.yml = our source/transform prefix + everything from upstream's `router:` down.
# Splitting at `router:` keeps us insulated from upstream changes to sinks and
# downstream transforms (they pass through unmodified); we only own the part
# that has to differ because we're not reading from the Docker socket.
COPY docker/fernwaerts/vector-source.yml /tmp/our-source.yml
RUN mkdir -p /etc/vector \
 && cp /tmp/our-source.yml /etc/vector/vector.yml \
 && awk '/^  router:/{p=1} p' /tmp/upstream-vector.yml >> /etc/vector/vector.yml \
 && rm /tmp/upstream-vector.yml /tmp/our-source.yml

RUN chmod +x /home/kong/kong-entrypoint.sh /entrypoint.sh

# s6 service definitions.
COPY docker/fernwaerts/s6/ /etc/s6-overlay/s6-rc.d/

# Per-service log directories. s6-log writes /var/log/<svc>/current here.
RUN set -eux; \
    for svc in auth rest functions powersync meta analytics studio kong vector init-migrator; do \
      mkdir -p "/var/log/${svc}"; \
      chmod 02750 "/var/log/${svc}"; \
    done

EXPOSE 8000 7901

ENTRYPOINT ["/init"]
