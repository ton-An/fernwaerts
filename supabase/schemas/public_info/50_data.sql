-- NEEDS_MANUAL_MODIFICATION - This file doesn't get applied using db diff, meaning it needs to be added manually to the migration file
insert into "public"."public_info" ("name", "value") values
  ('is_set_up', 'false');
