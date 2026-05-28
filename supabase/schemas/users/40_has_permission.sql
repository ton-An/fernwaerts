create or replace function public.has_permission(requested_permission public.permissions)
returns boolean
language sql
stable security invoker
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