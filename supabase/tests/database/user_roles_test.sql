BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('user_roles', 'authenticated', 'SELECT'),
  ARRAY['accepted_at', 'created_at', 'deleted_at', 'id', 'invited_at',
        'role', 'updated_at', 'user_id'],
  'authenticated can SELECT only the granted columns on user_roles'
);
SELECT is(
  test_helpers.table_grantees('user_roles'),
  ARRAY['authenticated'],
  'authenticated is the only role with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('user_roles', 'authenticated'),
  ARRAY['SELECT'],
  'authenticated has exactly SELECT privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
-- seed two users; give each a member role
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

INSERT INTO public.user_roles (id, user_id, role, accepted_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'member', now()),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '22222222-2222-2222-2222-222222222222', 'admin', now());

-- allowed: user reads only their own role
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT results_eq(
  $$SELECT id FROM public.user_roles ORDER BY id$$,
  $$VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid)$$,
  'allowed: authenticated user sees only own user_roles row'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: user cannot read another user's role row
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT is_empty(
  $$SELECT id FROM public.user_roles
    WHERE id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'$$,
  'denied: authenticated user cannot SELECT another user''s role'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
