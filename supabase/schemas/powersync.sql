-- Set the password outside migrations for deployed environments.
create role powersync_role with replication bypassrls login;

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
