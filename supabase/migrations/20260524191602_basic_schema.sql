create extension postgis with schema "extensions";
create extension if not exists pgtap with schema "extensions";

create type "public"."permissions" as enum ('read.users', 'write.users');

create type "public"."roles" as enum ('admin', 'member');

create table "public"."role_permissions" (
  "id" uuid not null default gen_random_uuid(),
  "role" public.roles not null,
  "permission" public.permissions not null,
  "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "deleted_at" timestamp with time zone,
  primary key ("id")
    );

alter table "public"."role_permissions" enable row level security;

create policy "Enable read access for all users"
  on "public"."role_permissions"
  as permissive
  for select
  to authenticated
using (true);

create table "public"."users" (
    "id" uuid not null references auth.users(id),
    "email" text not null,
    "username" text not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "deleted_at" timestamp with time zone,
    primary key ("id")
  );

create table "public"."public_info" (
  "id" text not null default gen_random_uuid(),
  "name" text not null,
  "value" jsonb not null,
  primary key ("id")
);

create table "public"."user_roles" (
  "id" uuid not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id),
  "role" public.roles not null,
  "invited_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "accepted_at" timestamp with time zone,
  "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  "deleted_at" timestamp with time zone,
  primary key ("id")
    );

create type "public"."operating_system" as enum (
  'android',
  'ios',
  'windows',
  'linux',
  'macos',
  'web',
  'unknown'
);

create table "public"."devices" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "name" text not null,
  "model" text not null,
  "os_id" public.operating_system not null default 'unknown',
  "os_version" text not null,
  "app_version" text not null,
  "manufacturer" text not null,
  "created_at" timestamp with time zone not null,
  "updated_at" timestamp with time zone not null,
  primary key ("id"),
  unique ("user_id", "id")
);

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

create table "public"."visits" (
  "id" text not null default gen_random_uuid(),
  "user_id" uuid not null references public.users(id) on delete cascade,
  "name" text not null,
  "arrival_location_id" text,
  "departure_location_id" text,
  primary key ("id"),
  unique ("user_id", "id"),
  foreign key ("user_id", "arrival_location_id")
    references public.raw_location_data("user_id", "id"),
  foreign key ("user_id", "departure_location_id")
    references public.raw_location_data("user_id", "id")
);

create or replace function public.has_permission(requested_permission public.permissions)
returns boolean
language sql
stable security definer
set search_path to ''
as $$
  select exists (
    select 1
    from public.user_roles
    join public.role_permissions
      on role_permissions.role = user_roles.role
    where user_roles.user_id = (select auth.uid())
      and user_roles.accepted_at is not null
      and user_roles.deleted_at is null
      and role_permissions.permission = requested_permission
  );
$$;

alter table "public"."users" enable row level security;

create policy "Enable select of self + users if read perm"
  on "public"."users"
  as permissive
  for select
  to authenticated
using (
  (( select auth.uid() as uid) = id)
  or 
  (exists 
    ( select 1 
      from public.user_roles target_roles
        where (
        (target_roles.user_id = users.id) 
        and 
        (target_roles.deleted_at is null) 
        and 
        public.has_permission('read.users')
        )
      )
    )
  );

alter table "public"."user_roles" enable row level security;

create policy "Enable select of self + other users if read perm"
  on "public"."user_roles"
  as permissive
  for select
  to authenticated
using (
    deleted_at is null
    and 
    (
      ( select auth.uid() as uid ) = user_id
      or 
      public.has_permission('read.users')
    )
  );

alter table "public"."public_info" enable row level security;

create policy "Enable read access for all users"
  on "public"."public_info"
  as permissive
  for select
  to public
using (true);

alter table "public"."devices" enable row level security;

create policy "Enable select for user himself"
  on "public"."devices"
  as permissive
  for select
  to authenticated
using (((select auth.uid()) = user_id));

create policy "Enable insert for user himself"
  on "public"."devices"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

alter table "public"."raw_location_data" enable row level security;

create policy "Enable select for user himself"
  on "public"."raw_location_data"
  as permissive
  for select
  to authenticated
using (((select auth.uid()) = user_id));

create policy "Enable insert for user himself"
  on "public"."raw_location_data"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

alter table "public"."activity_segments" enable row level security;

create policy "Enable select for user himself"
  on "public"."activity_segments"
  as permissive
  for select
  to authenticated
using (((select auth.uid()) = user_id));

create policy "Enable insert for user himself"
  on "public"."activity_segments"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

alter table "public"."visits" enable row level security;

create policy "Enable select for user himself"
  on "public"."visits"
  as permissive
  for select
  to authenticated
using (((select auth.uid()) = user_id));

create policy "Enable insert for user himself"
  on "public"."visits"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

create extension if not exists "moddatetime" with schema "extensions";

create trigger handle_updated_at before update on public.user_roles for each row execute function extensions.moddatetime ('updated_at');
create trigger handle_updated_at before update on public.users for each row execute function extensions.moddatetime ('updated_at');

------------------------
-- Manual modifications
------------------------

-- role_permissions
revoke select, insert, update, delete, references, trigger, truncate on table "public"."role_permissions" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."role_permissions" from authenticated;

grant select on table "public"."role_permissions" to authenticated;

insert into "public"."role_permissions" ("id", "role", "permission", "created_at", "updated_at", "deleted_at") VALUES
	('9c7ff33b-08d9-4082-b966-c503f6ec2207', 'admin', 'read.users', (now() AT TIME ZONE 'utc'::text), (now() AT TIME ZONE 'utc'::text), null),
	('35e876c2-809c-4d3d-9a01-56e1cabbeddf', 'admin', 'write.users', (now() AT TIME ZONE 'utc'::text), (now() AT TIME ZONE 'utc'::text), null);

-- users
revoke select, insert, update, delete, references, trigger, truncate on table "public"."users" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."users" from authenticated;

grant select on table "public"."users" to authenticated;

-- user_roles
revoke select, insert, update, delete, references, trigger, truncate on table "public"."user_roles" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."user_roles" from authenticated;

grant select on table "public"."user_roles" to authenticated;

-- public_info
revoke select, insert, update, delete, references, trigger, truncate on table "public"."public_info" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."public_info" from authenticated;

grant select on table "public"."public_info" to anon;
grant select on table "public"."public_info" to authenticated;

insert into "public"."public_info" ("name", "value") values
  ('is_set_up', 'false');

-- devices
revoke select, insert, update, delete, references, trigger, truncate on table "public"."devices" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."devices" from authenticated;

grant select, insert on table "public"."devices" to authenticated;

-- raw_location_data
revoke select, insert, update, delete, references, trigger, truncate on table "public"."raw_location_data" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."raw_location_data" from authenticated;

grant select, insert on table "public"."raw_location_data" to authenticated;

-- activity_segments
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activity_segments" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activity_segments" from authenticated;

grant select, insert on table "public"."activity_segments" to authenticated;

-- visits
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from authenticated;

grant select, insert on table "public"."visits" to authenticated;
