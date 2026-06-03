BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('public_info', 'anon', 'SELECT'),
  ARRAY['id', 'name', 'value'],
  'anon can SELECT only the granted columns on public_info'
);
SELECT is(
  test_helpers.table_grantees('public_info'),
  ARRAY['anon', 'authenticated'],
  'anon and authenticated are the roles with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('public_info', 'anon'),
  ARRAY['SELECT'],
  'anon has exactly SELECT privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
-- The policy is `to public using (true)`. Both anon and signed-in users must see
-- the catalog row that drives the setup wizard.

-- allowed: anon (the setup wizard runs before any user exists)
SET LOCAL ROLE anon;
SELECT isnt_empty(
  $$SELECT name FROM public.public_info WHERE name = 'is_set_up'$$,
  'allowed: anon can SELECT the is_set_up row'
);
RESET ROLE;

-- allowed: authenticated
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT isnt_empty(
  $$SELECT name FROM public.public_info WHERE name = 'is_set_up'$$,
  'allowed: authenticated can SELECT the is_set_up row'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
