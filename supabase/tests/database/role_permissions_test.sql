BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('role_permissions', 'authenticated', 'SELECT'),
  ARRAY['id', 'permission', 'role'],
  'authenticated can SELECT only the granted columns on role_permissions'
);
SELECT is(
  test_helpers.table_grantees('role_permissions'),
  ARRAY['authenticated'],
  'authenticated is the only role with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('role_permissions', 'authenticated'),
  ARRAY['SELECT'],
  'authenticated has exactly SELECT privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
-- The policy is `using (true)` for authenticated, so every authenticated user
-- can read every row. Catalog rows are seeded by the migration; verify them.
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');

SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT bag_eq(
  $$SELECT role::text, permission::text FROM public.role_permissions$$,
  $$VALUES ('admin', 'read.users'), ('admin', 'write.users')$$,
  'allowed: authenticated sees the full role_permissions catalog'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: anon has no grant, SELECT raises insufficient_privilege
SET LOCAL ROLE anon;
SELECT throws_ok(
  $$SELECT id FROM public.role_permissions$$,
  '42501',
  NULL,
  'denied: anon cannot SELECT from role_permissions (no grant)'
);
RESET ROLE;

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
