create type "public"."activity_type" as enum ('still', 'walking', 'on_foot', 'running', 'on_bicycle', 'in_vehicle', 'unknown');

create type "public"."location_recording_trigger" as enum ('standard', 'significant_change');

create type "public"."operating_system" as enum ('android', 'ios', 'windows', 'linux', 'macos', 'web', 'unknown');

create type "public"."permissions" as enum ('read.users', 'write.users');

create type "public"."roles" as enum ('admin', 'member');


  create table "public"."activity_segments" (
    "id" text not null default gen_random_uuid(),
    "user_id" uuid not null,
    "start_location_id" text,
    "end_location_id" text
      );


alter table "public"."activity_segments" enable row level security;


  create table "public"."devices" (
    "id" text not null default gen_random_uuid(),
    "user_id" uuid not null,
    "name" text not null,
    "model" text not null,
    "os_id" public.operating_system not null default 'unknown'::public.operating_system,
    "os_version" text not null,
    "app_version" text not null,
    "manufacturer" text not null,
    "created_at" timestamp with time zone not null,
    "updated_at" timestamp with time zone not null
      );


alter table "public"."devices" enable row level security;


  create table "public"."public_info" (
    "id" text not null default gen_random_uuid(),
    "name" text not null,
    "value" jsonb not null
      );


alter table "public"."public_info" enable row level security;


  create table "public"."raw_location_data" (
    "id" text not null default gen_random_uuid(),
    "user_id" uuid not null,
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
    "activity_type_id" public.activity_type not null default 'unknown'::public.activity_type,
    "activity_confidence" double precision not null,
    "recording_trigger" public.location_recording_trigger not null default 'standard'::public.location_recording_trigger,
    "battery_level" double precision not null,
    "is_device_charging" boolean not null,
    "timestamp" timestamp with time zone not null
      );


alter table "public"."raw_location_data" enable row level security;


  create table "public"."role_permissions" (
    "id" uuid not null default gen_random_uuid(),
    "role" public.roles not null,
    "permission" public.permissions not null
      );


alter table "public"."role_permissions" enable row level security;


  create table "public"."user_roles" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "role" public.roles not null,
    "invited_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "accepted_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "deleted_at" timestamp with time zone
      );


alter table "public"."user_roles" enable row level security;


  create table "public"."users" (
    "id" uuid not null,
    "email" text not null,
    "username" text not null,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "updated_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
    "deleted_at" timestamp with time zone
      );


alter table "public"."users" enable row level security;


  create table "public"."visits" (
    "id" text not null default gen_random_uuid(),
    "user_id" uuid not null,
    "name" text not null,
    "arrival_location_id" text,
    "departure_location_id" text
      );


alter table "public"."visits" enable row level security;

CREATE UNIQUE INDEX activity_segments_pkey ON public.activity_segments USING btree (id);

CREATE UNIQUE INDEX activity_segments_user_id_id_key ON public.activity_segments USING btree (user_id, id);

CREATE UNIQUE INDEX devices_pkey ON public.devices USING btree (id);

CREATE UNIQUE INDEX devices_user_id_id_key ON public.devices USING btree (user_id, id);

CREATE UNIQUE INDEX public_info_pkey ON public.public_info USING btree (id);

CREATE UNIQUE INDEX raw_location_data_pkey ON public.raw_location_data USING btree (id);

CREATE UNIQUE INDEX raw_location_data_user_id_id_key ON public.raw_location_data USING btree (user_id, id);

CREATE UNIQUE INDEX role_permissions_pkey ON public.role_permissions USING btree (id);

CREATE UNIQUE INDEX user_roles_pkey ON public.user_roles USING btree (id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

CREATE UNIQUE INDEX visits_pkey ON public.visits USING btree (id);

CREATE UNIQUE INDEX visits_user_id_id_key ON public.visits USING btree (user_id, id);

alter table "public"."activity_segments" add constraint "activity_segments_pkey" PRIMARY KEY using index "activity_segments_pkey";

alter table "public"."devices" add constraint "devices_pkey" PRIMARY KEY using index "devices_pkey";

alter table "public"."public_info" add constraint "public_info_pkey" PRIMARY KEY using index "public_info_pkey";

alter table "public"."raw_location_data" add constraint "raw_location_data_pkey" PRIMARY KEY using index "raw_location_data_pkey";

alter table "public"."role_permissions" add constraint "role_permissions_pkey" PRIMARY KEY using index "role_permissions_pkey";

alter table "public"."user_roles" add constraint "user_roles_pkey" PRIMARY KEY using index "user_roles_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."visits" add constraint "visits_pkey" PRIMARY KEY using index "visits_pkey";

alter table "public"."activity_segments" add constraint "activity_segments_user_id_end_location_id_fkey" FOREIGN KEY (user_id, end_location_id) REFERENCES public.raw_location_data(user_id, id) not valid;

alter table "public"."activity_segments" validate constraint "activity_segments_user_id_end_location_id_fkey";

alter table "public"."activity_segments" add constraint "activity_segments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."activity_segments" validate constraint "activity_segments_user_id_fkey";

alter table "public"."activity_segments" add constraint "activity_segments_user_id_id_key" UNIQUE using index "activity_segments_user_id_id_key";

alter table "public"."activity_segments" add constraint "activity_segments_user_id_start_location_id_fkey" FOREIGN KEY (user_id, start_location_id) REFERENCES public.raw_location_data(user_id, id) not valid;

alter table "public"."activity_segments" validate constraint "activity_segments_user_id_start_location_id_fkey";

alter table "public"."devices" add constraint "devices_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."devices" validate constraint "devices_user_id_fkey";

alter table "public"."devices" add constraint "devices_user_id_id_key" UNIQUE using index "devices_user_id_id_key";

alter table "public"."raw_location_data" add constraint "raw_location_data_user_id_device_id_fkey" FOREIGN KEY (user_id, device_id) REFERENCES public.devices(user_id, id) not valid;

alter table "public"."raw_location_data" validate constraint "raw_location_data_user_id_device_id_fkey";

alter table "public"."raw_location_data" add constraint "raw_location_data_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."raw_location_data" validate constraint "raw_location_data_user_id_fkey";

alter table "public"."raw_location_data" add constraint "raw_location_data_user_id_id_key" UNIQUE using index "raw_location_data_user_id_id_key";

alter table "public"."user_roles" add constraint "user_roles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) not valid;

alter table "public"."user_roles" validate constraint "user_roles_user_id_fkey";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) not valid;

alter table "public"."users" validate constraint "users_id_fkey";

alter table "public"."visits" add constraint "visits_user_id_arrival_location_id_fkey" FOREIGN KEY (user_id, arrival_location_id) REFERENCES public.raw_location_data(user_id, id) not valid;

alter table "public"."visits" validate constraint "visits_user_id_arrival_location_id_fkey";

alter table "public"."visits" add constraint "visits_user_id_departure_location_id_fkey" FOREIGN KEY (user_id, departure_location_id) REFERENCES public.raw_location_data(user_id, id) not valid;

alter table "public"."visits" validate constraint "visits_user_id_departure_location_id_fkey";

alter table "public"."visits" add constraint "visits_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."visits" validate constraint "visits_user_id_fkey";

alter table "public"."visits" add constraint "visits_user_id_id_key" UNIQUE using index "visits_user_id_id_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.has_permission(requested_permission public.permissions)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
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
$function$
;

grant insert on table "public"."activity_segments" to "authenticated";

grant delete on table "public"."activity_segments" to "service_role";

grant insert on table "public"."activity_segments" to "service_role";

grant references on table "public"."activity_segments" to "service_role";

grant select on table "public"."activity_segments" to "service_role";

grant trigger on table "public"."activity_segments" to "service_role";

grant truncate on table "public"."activity_segments" to "service_role";

grant update on table "public"."activity_segments" to "service_role";

grant insert on table "public"."devices" to "authenticated";

grant delete on table "public"."devices" to "service_role";

grant insert on table "public"."devices" to "service_role";

grant references on table "public"."devices" to "service_role";

grant select on table "public"."devices" to "service_role";

grant trigger on table "public"."devices" to "service_role";

grant truncate on table "public"."devices" to "service_role";

grant update on table "public"."devices" to "service_role";

grant select on table "public"."public_info" to "anon";

grant select on table "public"."public_info" to "authenticated";

grant delete on table "public"."public_info" to "service_role";

grant insert on table "public"."public_info" to "service_role";

grant references on table "public"."public_info" to "service_role";

grant select on table "public"."public_info" to "service_role";

grant trigger on table "public"."public_info" to "service_role";

grant truncate on table "public"."public_info" to "service_role";

grant update on table "public"."public_info" to "service_role";

grant insert on table "public"."raw_location_data" to "authenticated";

grant delete on table "public"."raw_location_data" to "service_role";

grant insert on table "public"."raw_location_data" to "service_role";

grant references on table "public"."raw_location_data" to "service_role";

grant select on table "public"."raw_location_data" to "service_role";

grant trigger on table "public"."raw_location_data" to "service_role";

grant truncate on table "public"."raw_location_data" to "service_role";

grant update on table "public"."raw_location_data" to "service_role";

grant delete on table "public"."role_permissions" to "service_role";

grant insert on table "public"."role_permissions" to "service_role";

grant references on table "public"."role_permissions" to "service_role";

grant select on table "public"."role_permissions" to "service_role";

grant trigger on table "public"."role_permissions" to "service_role";

grant truncate on table "public"."role_permissions" to "service_role";

grant update on table "public"."role_permissions" to "service_role";

grant delete on table "public"."user_roles" to "service_role";

grant insert on table "public"."user_roles" to "service_role";

grant references on table "public"."user_roles" to "service_role";

grant select on table "public"."user_roles" to "service_role";

grant trigger on table "public"."user_roles" to "service_role";

grant truncate on table "public"."user_roles" to "service_role";

grant update on table "public"."user_roles" to "service_role";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

grant insert on table "public"."visits" to "authenticated";

grant delete on table "public"."visits" to "service_role";

grant insert on table "public"."visits" to "service_role";

grant references on table "public"."visits" to "service_role";

grant select on table "public"."visits" to "service_role";

grant trigger on table "public"."visits" to "service_role";

grant truncate on table "public"."visits" to "service_role";

grant update on table "public"."visits" to "service_role";


  create policy "Enable insert for user himself"
  on "public"."activity_segments"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Enable insert for user himself"
  on "public"."devices"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Enable read access for all users"
  on "public"."public_info"
  as permissive
  for select
  to public
using (true);



  create policy "Enable insert for user himself"
  on "public"."raw_location_data"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Enable insert for user himself"
  on "public"."visits"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));


create extension if not exists moddatetime with schema extensions;

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');

------------------------
-- Manual modifications
------------------------

-- role_permissions
revoke select, insert, update, delete, references, trigger, truncate on table "public"."role_permissions" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."role_permissions" from authenticated;

insert into "public"."role_permissions" ("id", "role", "permission") VALUES
	('9c7ff33b-08d9-4082-b966-c503f6ec2207', 'admin', 'read.users'),
	('35e876c2-809c-4d3d-9a01-56e1cabbeddf', 'admin', 'write.users');

-- users
revoke select, insert, update, delete, references, trigger, truncate on table "public"."users" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."users" from authenticated;

-- user_roles
revoke select, insert, update, delete, references, trigger, truncate on table "public"."user_roles" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."user_roles" from authenticated;

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

grant insert on table "public"."devices" to authenticated;

-- raw_location_data
revoke select, insert, update, delete, references, trigger, truncate on table "public"."raw_location_data" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."raw_location_data" from authenticated;

grant insert on table "public"."raw_location_data" to authenticated;

-- activity_segments
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activity_segments" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activity_segments" from authenticated;

grant insert on table "public"."activity_segments" to authenticated;

-- visits
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from authenticated;

grant insert on table "public"."visits" to authenticated;

-- powersync (supabase db diff does not capture roles or publications)
create role powersync_role with login replication bypassrls;

grant select on
  public.public_info,
  public.role_permissions,
  public.users,
  public.devices,
  public.raw_location_data,
  public.activity_segments,
  public.visits,
  public.user_roles
to powersync_role;

create publication powersync for table
  public.public_info,
  public.role_permissions,
  public.users,
  public.devices,
  public.raw_location_data,
  public.activity_segments,
  public.visits,
  public.user_roles;
