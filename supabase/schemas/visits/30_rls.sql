alter table "public"."visits" enable row level security;

create policy "Enable insert for user himself"
  on "public"."visits"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

create policy "Enable select for user himself"
  on "public"."visits"
  as permissive
  for select
  to authenticated
  using (((select auth.uid()) = user_id));

create policy "Enable update for user himself"
  on "public"."visits"
  as permissive
  for update
  to authenticated
  using (((select auth.uid()) = user_id))
with check (((select auth.uid()) = user_id));
