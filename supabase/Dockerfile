# ToDo: apply proper permissions and allow rootless

FROM node:latest

# Set working directory
WORKDIR /supabase

RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Install Supabase CLI
RUN npm i supabase --save-dev

# Update Supabase CLI
RUN npm update supabase --save-dev

# Copy supabase config files
COPY ./migrations/ migrations/
COPY ./schemas/ schemas/

# Copy config.toml
COPY ./migration_config.toml config.toml

# Copy edge functions
COPY ./functions/ functions/

CMD ["sh", "-ec", "cp -r functions/. /functions/  && chmod -R a+rX /functions/; \
  : \"${PS_SOURCE_PASSWORD:?PS_SOURCE_PASSWORD is required}\"; \
  until [ \"$(curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal:$API_PORT)\" = \"401\" ]; do echo 'Waiting for web service...'; sleep 1; done && echo 'Web service is up!'; \
  npx supabase db push --yes --db-url $SUPABASE_DB_URL; \
  psql \"$SUPABASE_DB_URL\" -v ON_ERROR_STOP=1 -v powersync_password=\"$PS_SOURCE_PASSWORD\" <<'SQL'\nALTER ROLE powersync_role WITH PASSWORD :'powersync_password';\nSQL\n"]
