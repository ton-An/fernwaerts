alter table "public"."devices" enable row level security;

create policy "Enable insert for user himself"
  on "public"."devices"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));