alter table "public"."activity_segments" enable row level security;

create policy "Enable insert for user himself"
  on "public"."activity_segments"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));

create policy "Enable select for user himself"
  on "public"."activity_segments"
  as permissive
  for select
  to authenticated
  using (((select auth.uid()) = user_id));

create policy "Enable update for user himself"
  on "public"."activity_segments"
  as permissive
  for update
  to authenticated
  using (((select auth.uid()) = user_id))
with check (((select auth.uid()) = user_id));
