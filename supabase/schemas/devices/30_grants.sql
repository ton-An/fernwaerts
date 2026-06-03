-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
revoke select, insert, update, delete, references, trigger, truncate on table "public"."devices" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."devices" from authenticated;

grant select (id, user_id, name, model, os_id, os_version, app_version, manufacturer)
  on table "public"."devices" to authenticated;
grant insert (id, user_id, name, model, os_id, os_version, app_version, manufacturer)
  on table "public"."devices" to authenticated;
grant update (id, user_id, name, model, os_id, os_version, app_version, manufacturer)
  on table "public"."devices" to authenticated;
