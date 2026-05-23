-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
revoke select, insert, update, delete, references, trigger, truncate on table "public"."public_info" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."public_info" from authenticated;

grant select on table "public"."public_info" to anon;
grant select on table "public"."public_info" to authenticated;
