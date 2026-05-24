create table "public"."places" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "location_id" text not null,
  primary key ("id"),
  unique ("user_id", "id"),
  foreign key ("user_id", "location_id")
    references public.raw_location_data("user_id", "id")
);
