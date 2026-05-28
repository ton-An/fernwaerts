alter table "public"."user_roles" enable row level security;

create policy "users can read own role"
  on "public"."user_roles"
  for select
  to authenticated
  using (user_id = (select auth.uid()));