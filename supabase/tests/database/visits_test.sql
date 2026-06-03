BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('visits', 'authenticated', 'INSERT'),
  ARRAY['arrival_location_id', 'departure_location_id', 'id', 'name', 'user_id'],
  'authenticated can INSERT every column on visits'
);
SELECT is(
  test_helpers.table_grantees('visits'),
  ARRAY['authenticated'],
  'authenticated is the only role with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('visits', 'authenticated'),
  ARRAY['INSERT', 'SELECT', 'UPDATE'],
  'authenticated has exactly INSERT, SELECT, UPDATE privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

INSERT INTO public.visits (id, user_id, name) VALUES
  ('visit-owner', '11111111-1111-1111-1111-111111111111', 'Home'),
  ('visit-other', '22222222-2222-2222-2222-222222222222', 'Office');

-- allowed: owner sees only their own visits
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT results_eq(
  $$SELECT id FROM public.visits ORDER BY id$$,
  $$VALUES ('visit-owner'::text)$$,
  'allowed: authenticated owner sees only own visits'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: non-owner cannot read another user's visit
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('22222222-2222-2222-2222-222222222222');
SELECT is_empty(
  $$SELECT id FROM public.visits WHERE id = 'visit-owner'$$,
  'denied: non-owner cannot SELECT another user''s visit'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: INSERT ------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$INSERT INTO public.visits (id, user_id, name)
    VALUES ('visit-spoof', '22222222-2222-2222-2222-222222222222', 'Spoof')$$,
  '42501',
  NULL,
  'denied: authenticated cannot INSERT a visit for a different user_id'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: UPDATE ------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT is_empty(
  $$WITH updated AS (
      UPDATE public.visits SET name = 'hijacked'
      WHERE id = 'visit-other'
      RETURNING id
    )
    SELECT id FROM updated$$,
  'denied: non-owner UPDATE returns no rows'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: owner cannot reassign their own row to another user_id (WITH CHECK)
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$UPDATE public.visits
    SET user_id = '22222222-2222-2222-2222-222222222222'
    WHERE id = 'visit-owner'$$,
  '42501',
  NULL,
  'denied: owner cannot UPDATE user_id to another user (WITH CHECK)'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
