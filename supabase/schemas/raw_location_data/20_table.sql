create table "public"."raw_location_data" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "device_id" text not null,
  "latitude" double precision not null,
  "longitude" double precision not null,
  "coordinates_accuracy" double precision not null,
  "speed" double precision not null,
  "speed_accuracy" double precision not null,
  "heading" double precision not null,
  "heading_accuracy" double precision not null,
  "ellipsoidal_altitude" double precision not null,
  "altitude_accuracy" double precision not null,
  "activity_type_id" public.activity_type not null default 'unknown',
  "activity_confidence" double precision not null,
  "recording_trigger" public.location_recording_trigger not null default 'standard',
  "battery_level" double precision not null,
  "is_device_charging" boolean not null,
  "timestamp" timestamp with time zone not null,
  primary key ("id"),
  unique ("user_id", "id"),
  foreign key ("user_id", "device_id")
    references public.devices("user_id", "id")
);
