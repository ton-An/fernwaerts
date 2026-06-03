create table "public"."devices" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "name" text not null,
  "model" text not null,
  "os_id" public.operating_system not null default 'unknown',
  "os_version" text not null,
  "app_version" text not null,
  "manufacturer" text not null,
  "created_at" timestamp with time zone not null default (now() at time zone 'utc'::text),
  "updated_at" timestamp with time zone not null default (now() at time zone 'utc'::text),
  primary key ("id"),
  unique ("user_id", "id")
);
