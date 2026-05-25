-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."visits" from authenticated;

grant insert on table "public"."visits" to authenticated;
