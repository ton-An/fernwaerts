-- NEEDS_MANUAL_MODIFICATION - This doesn't get applied using db diff, meaning it needs to be added manually to the migration file
insert into "public"."role_permissions" ("id", "role", "permission", "created_at", "updated_at", "deleted_at") VALUES
	('9c7ff33b-08d9-4082-b966-c503f6ec2207', 'admin', 'read.users', (now() AT TIME ZONE 'utc'::text), (now() AT TIME ZONE 'utc'::text), null),
	('35e876c2-809c-4d3d-9a01-56e1cabbeddf', 'admin', 'write.users', (now() AT TIME ZONE 'utc'::text), (now() AT TIME ZONE 'utc'::text), null);
