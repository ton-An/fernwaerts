alter table "public"."visits" enable row level security;

create policy "Enable insert for user himself"
  on "public"."visits"
  as permissive
  for insert
  to authenticated
with check (((select auth.uid()) = user_id));
