create table "public"."public_info" (
  "id" text not null default gen_random_uuid(),
  "name" text not null,
  "value" jsonb not null,
  primary key ("id")
);
