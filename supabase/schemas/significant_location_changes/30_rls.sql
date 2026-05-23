alter table "public"."significant_location_changes" enable row level security;

create policy "Enable select for user himself"
  on "public"."significant_location_changes"
  as permissive
  for select
  to authenticated
using (((select auth.uid()) = user_id));

create policy "Enable insert for user himself"
  on "public"."significant_location_changes"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));