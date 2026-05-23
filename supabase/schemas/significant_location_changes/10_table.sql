create table "public"."significant_location_changes" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "location_id" text references public.raw_location_data(id),
  primary key ("id")
);
