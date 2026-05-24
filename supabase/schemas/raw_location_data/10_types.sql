create type "public"."activity_type" as enum (
  'still',
  'walking',
  'on_foot',
  'running',
  'on_bicycle',
  'in_vehicle',
  'unknown'
);

create type "public"."location_recording_trigger" as enum (
  'standard',
  'significant_change'
);
