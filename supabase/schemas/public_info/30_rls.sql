alter table "public"."public_info" enable row level security;

create policy "Enable read access for all users"
  on "public"."public_info"
  as permissive
  for select
  to public
using (true);
