BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------
-- All client-role privileges on public.users are revoked. Application code reads
-- the user's own row via auth.users / Edge Functions, never through this table.

SELECT is(
  test_helpers.table_grantees('users'),
  ARRAY[]::text[],
  'no client role has table-level privileges on users'
);
SELECT is(
  test_helpers.all_privs('users', 'authenticated'),
  ARRAY[]::text[],
  'authenticated has no privileges on users'
);

-- RLS: SELECT ------------------------------------------------------------------
-- The table has RLS enabled but defines no policies, so the API surface is fully
-- locked. The grant revoke trips first; this asserts the lockdown holds regardless.

SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');

SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$SELECT id FROM public.users$$,
  '42501',
  NULL,
  'denied: authenticated cannot SELECT from users (no grant)'
);
RESET ROLE; SELECT test_helpers.reset_actor();

SET LOCAL ROLE anon;
SELECT throws_ok(
  $$SELECT id FROM public.users$$,
  '42501',
  NULL,
  'denied: anon cannot SELECT from users (no grant)'
);
RESET ROLE;

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
