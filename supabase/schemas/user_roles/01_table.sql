create table "public"."user_roles" (
  "id" uuid not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id),
  "role" public.roles not null,
  "invited_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "accepted_at" timestamp with time zone,
  "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "deleted_at" timestamp with time zone,
  primary key ("id")
    );

  