create table "public"."activities" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "activity_type_id" public.activity_type,
  "start_location_id" text references public.raw_location_data(id),
  "end_location_id" text references public.raw_location_data(id),
  primary key ("id")
);
