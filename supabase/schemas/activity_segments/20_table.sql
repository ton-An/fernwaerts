create table "public"."activity_segments" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "start_location_id" text,
  "end_location_id" text,
  primary key ("id"),
  unique ("user_id", "id"),
  foreign key ("user_id", "start_location_id")
    references public.raw_location_data("user_id", "id"),
  foreign key ("user_id", "end_location_id")
    references public.raw_location_data("user_id", "id")
);
