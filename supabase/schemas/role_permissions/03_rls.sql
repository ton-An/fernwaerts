alter table "public"."role_permissions" enable row level security;

create policy "Enable read access for all users"
  on "public"."role_permissions"
  as permissive
  for select
  to authenticated
using (true);
