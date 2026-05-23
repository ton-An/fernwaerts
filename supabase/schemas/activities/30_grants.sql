-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activities" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."activities" from authenticated;

grant select, insert on table "public"."activities" to authenticated;
