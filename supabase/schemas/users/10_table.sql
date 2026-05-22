  create table "public"."users" (
    "id" uuid not null references auth.users(id),
    "email" text not null,
    "username" text not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "deleted_at" timestamp with time zone,
    primary key ("id")
  );