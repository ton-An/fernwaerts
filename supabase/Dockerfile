# ToDo: apply proper permissions and allow rootless

FROM node:latest

# Set working directory
WORKDIR /supabase

# Install Supabase CLI
RUN npm i supabase --save-dev

# Update Supabase CLI
RUN npm update supabase --save-dev

# Copy supabase config files
COPY ./migrations/ migrations/

# Copy config.toml
COPY ./migration_config.toml config.toml

# Copy edge functions
COPY ./functions/ functions/

CMD ["sh", "-c", "cp -r functions/. /functions/  && chmod -R a+rX /functions/; \
  until [ \"$(curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal:$API_PORT)\" = \"401\" ]; do echo 'Waiting for web service...'; sleep 1; done && echo 'Web service is up!'; \
  npx supabase db reset; \
  npx supabase db push --db-url $SUPABASE_DB_URL; \
  npx supabase stop;"]