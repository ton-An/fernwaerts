alter table "public"."user_roles" enable row level security;

create policy "Enable select of self + other users if read perm"
  on "public"."user_roles"
  as permissive
  for select
  to authenticated
using (
    deleted_at is null
    and 
    (
      ( select auth.uid() as uid ) = user_id
      or 
      public.has_permission('read.users')
    )
  );

