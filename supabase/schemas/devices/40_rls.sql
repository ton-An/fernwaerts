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