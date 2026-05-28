alter table "public"."role_permissions" enable row level security;

create policy "authenticated users can read role permissions"
  on "public"."role_permissions"
  for select
  to authenticated
  using (true);