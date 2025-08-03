#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  DO
  \$\$
  BEGIN
    CREATE USER powersync_storage_user WITH PASSWORD '${PS_STORAGE_PASSWORD}';
    GRANT CREATE ON DATABASE ${POSTGRES_DB} TO powersync_storage_user;
  END
  \$\$;
EOSQL

