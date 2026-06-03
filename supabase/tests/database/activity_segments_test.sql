BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('activity_segments', 'authenticated', 'INSERT'),
  ARRAY['end_location_id', 'id', 'start_location_id', 'user_id'],
  'authenticated can INSERT every column on activity_segments'
);
SELECT is(
  test_helpers.table_grantees('activity_segments'),
  ARRAY['authenticated'],
  'authenticated is the only role with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('activity_segments', 'authenticated'),
  ARRAY['INSERT', 'SELECT', 'UPDATE'],
  'authenticated has exactly INSERT, SELECT, UPDATE privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

INSERT INTO public.activity_segments (id, user_id) VALUES
  ('seg-owner', '11111111-1111-1111-1111-111111111111'),
  ('seg-other', '22222222-2222-2222-2222-222222222222');

-- allowed: owner sees only their own segments
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT results_eq(
  $$SELECT id FROM public.activity_segments ORDER BY id$$,
  $$VALUES ('seg-owner'::text)$$,
  'allowed: authenticated owner sees only own activity segments'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: non-owner cannot read another user's segment
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('22222222-2222-2222-2222-222222222222');
SELECT is_empty(
  $$SELECT id FROM public.activity_segments WHERE id = 'seg-owner'$$,
  'denied: non-owner cannot SELECT another user''s activity segment'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: INSERT ------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$INSERT INTO public.activity_segments (id, user_id)
    VALUES ('seg-spoof', '22222222-2222-2222-2222-222222222222')$$,
  '42501',
  NULL,
  'denied: authenticated cannot INSERT a segment for a different user_id'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: UPDATE ------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT is_empty(
  $$WITH updated AS (
      UPDATE public.activity_segments SET start_location_id = NULL
      WHERE id = 'seg-other'
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
  $$UPDATE public.activity_segments
    SET user_id = '22222222-2222-2222-2222-222222222222'
    WHERE id = 'seg-owner'$$,
  '42501',
  NULL,
  'denied: owner cannot UPDATE user_id to another user (WITH CHECK)'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
