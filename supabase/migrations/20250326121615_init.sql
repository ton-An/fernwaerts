-- ToDo: Maybe harden the data api by dropping the public schema and creating our own (see: https://supabase.com/docs/guides/database/hardening-data-api)
-- Custom types
create type public.app_role as enum ('admin', 'user');

-- USERS
create table
  public.users (
    id uuid references auth.users not null primary key,
    username text not null,
    email text not null unique
  );

alter table public.users enable row level security;

create policy "Enable read access for user himself" on public.users for
select
  to authenticated using (
    (
      select
        auth.uid ()
    ) = id
  );

-- USER ROLES
create table
  public.user_roles (
    id uuid default gen_random_uuid () primary key,
    user_id uuid references public.users on delete cascade not null,
    role app_role not null,
    unique (user_id, role)
  );

alter table public.user_roles enable row level security;

create index ix_user_roles_user_id on public.user_roles (user_id);

-- Public Info
create table
  public.public_info (
    id uuid default gen_random_uuid () primary key,
    name text not null,
    value jsonb not null
  );

alter table public.public_info enable row level security;

create policy "Enable read access for all users" on public.public_info for
select
  to public using (true);

insert into
  public.public_info (name, value)
values
  ('is_set_up', 'false');

-- Devices
create table
  public.devices (
    id uuid default gen_random_uuid () primary key,
    user_id uuid references public.users on delete cascade not null,
    name text not null,
    model text not null,
    os text not null,
    os_version text not null,
    app_version text not null,
    manufacturer text not null,
    created_at TIMESTAMPTZ not null,
    updated_at TIMESTAMPTZ not null
  );

alter table public.devices enable row level security;

create policy "Enable full access for user himself" on public.devices for all to authenticated using (
  (
    select
      auth.uid ()
  ) = user_id
)
with
  check (auth.uid () = user_id);

-- Activity Types
create table
  public.activity_types (id text not null primary key);

alter table public.activity_types enable row level security;

create policy "Enable read access to all authenticated users" on public.activity_types for
select
  to authenticated;

insert into
  public.activity_types (id)
values
  ('still'),
  ('walking'),
  ('on_foot'),
  ('running'),
  ('on_bicycle'),
  ('in_vehicle'),
  ('unknown');

-- Raw Location Data
create table
  public.raw_location_data (
    id uuid default gen_random_uuid () primary key,
    user_id uuid references public.users on delete cascade not null,
    device_id uuid references devices (id),
    latitude double precision not null,
    longitude double precision not null,
    coordinates_accuracy double precision not null,
    speed double precision not null,
    speed_accuracy double precision not null,
    heading double precision not null,
    heading_accuracy double precision not null,
    ellipsoidal_altitude double precision not null,
    altitude_accuracy double precision not null,
    activity_type_id text references activity_types (id),
    activity_confidence double precision not null,
    battery_level double precision not null,
    is_device_charging boolean not null,
    timestamp TIMESTAMPTZ not null
  );

alter table public.raw_location_data enable row level security;

create policy "Enable full access for user himself" on public.raw_location_data for all to authenticated using (
  (
    select
      auth.uid ()
  ) = user_id
)
with
  check (auth.uid () = user_id);

-- Activities
-- ToDo: Could add the confidence. Though the level usually changes during the activity.
create table
  public.activities (
    id uuid default gen_random_uuid () primary key,
    user_id uuid references public.users on delete cascade not null,
    activity_type_id text references activity_types (id),
    start_location_id uuid references raw_location_data (id),
    end_location_id uuid references raw_location_data (id)
  );

alter table public.activities enable row level security;

create policy "Enable full access for user himself" on public.activities for all to authenticated using (
  (
    select
      auth.uid ()
  ) = user_id
)
with
  check (auth.uid () = user_id);

-- Significant Location Changes
create table
  public.significant_location_changes (
    id uuid default gen_random_uuid () primary key,
    user_id uuid references public.users on delete cascade not null,
    location_id uuid references raw_location_data (id)
  );

alter table public.significant_location_changes enable row level security;

create policy "Enable full access for user himself" on public.significant_location_changes for all to authenticated using (
  (
    select
      auth.uid ()
  ) = user_id
)
with
  check (auth.uid () = user_id);