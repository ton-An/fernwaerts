create table "public"."visits" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "place_id" text,
  "arrival_location_id" text,
  "departure_location_id" text,
  primary key ("id"),
  unique ("user_id", "id"),
  foreign key ("user_id", "place_id")
    references public.places("user_id", "id"),
  foreign key ("user_id", "arrival_location_id")
    references public.raw_location_data("user_id", "id"),
  foreign key ("user_id", "departure_location_id")
    references public.raw_location_data("user_id", "id")
);
