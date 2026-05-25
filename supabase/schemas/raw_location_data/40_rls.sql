alter table "public"."raw_location_data" enable row level security;

create policy "Enable insert for user himself"
  on "public"."raw_location_data"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));
