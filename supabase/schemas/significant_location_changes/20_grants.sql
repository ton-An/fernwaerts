-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
revoke select, insert, update, delete, references, trigger, truncate on table "public"."significant_location_changes" from anon;
revoke select, insert, update, delete, references, trigger, truncate on table "public"."significant_location_changes" from authenticated;

grant select, insert on table "public"."significant_location_changes" to authenticated;
