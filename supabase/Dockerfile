FROM node:latest

# Set working directory
WORKDIR /supabase

# Install Supabase CLI
RUN npm i supabase --save-dev

# Copy supabase config files
COPY ./migrations/ /supabase/migrations/

COPY ./migration_config.toml /supabase/config.toml

#"echo $POSTGRES_HOST:$POSTGRES_PORT",
#CMD ["sh", "-c",  "/usr/local/bin/wait-for-it.sh $SUPABASE_DB_URL -- npx supabase start || npx supabase db reset || npx supabase db push --include-seed --db-url $SUPABASE_DB_URL"]
#CMD ["sh", "-c", "npx supabase start || npx supabase db reset || npx supabase db push --include-seed --db-url $SUPABASE_DB_URL"]

CMD ["sh", "-c", "npx supabase start & \
  echo $API_PORT; \
  until [ \"$(curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal:$API_PORT)\" = \"401\" ]; do echo 'Waiting for web service...'; sleep 1; done && echo 'Web service is up!'; \
  npx supabase db reset; \
  npx supabase db push --db-url $SUPABASE_DB_URL; \
  npx supabase stop"]