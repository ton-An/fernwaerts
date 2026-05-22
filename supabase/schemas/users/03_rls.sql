alter table "public"."users" enable row level security;

create policy "Enable select of self + users if read perm"
  on "public"."users"
  as permissive
  for select
  to authenticated
using (
  (( select auth.uid() as uid) = id)
  or 
  (exists 
    ( select 1 
      from public.user_roles target_roles
        where (
        (target_roles.user_id = users.id) 
        and 
        (target_roles.deleted_at is null) 
        and 
        public.has_permission('read.users')
        )
      )
    )
  );

