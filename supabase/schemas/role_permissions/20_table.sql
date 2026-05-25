create table "public"."role_permissions" (
  "id" uuid not null default gen_random_uuid(),
  "role" public.roles not null,
  "permission" public.permissions not null,
  primary key ("id")
    );
