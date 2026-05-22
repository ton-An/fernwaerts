create table "public"."role_permissions" (
  "id" uuid not null default gen_random_uuid(),
  "role" public.roles not null,
  "permission" public.permissions not null,
  "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "deleted_at" timestamp with time zone,
  primary key ("id")
    );
