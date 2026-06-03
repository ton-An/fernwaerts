BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('devices', 'authenticated', 'SELECT'),
  ARRAY['app_version', 'id', 'manufacturer', 'model',
        'name', 'os_id', 'os_version', 'user_id'],
  'authenticated can SELECT only the granted columns on devices (created_at/updated_at hidden)'
);
SELECT is(
  test_helpers.col_privs('devices', 'authenticated', 'INSERT'),
  ARRAY['app_version', 'id', 'manufacturer', 'model',
        'name', 'os_id', 'os_version', 'user_id'],
  'authenticated can INSERT only the granted columns on devices (created_at/updated_at are server-managed)'
);
SELECT is(
  test_helpers.table_grantees('devices'),
  ARRAY[]::text[],
  'no role has table-level privileges (authenticated grants are column-level only)'
);
SELECT is(
  test_helpers.all_privs('devices', 'authenticated'),
  ARRAY['INSERT', 'SELECT', 'UPDATE'],
  'authenticated has exactly INSERT, SELECT, UPDATE privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
-- seed two users with one device each
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

INSERT INTO public.devices (id, user_id, name, model, os_version, app_version, manufacturer, created_at, updated_at)
VALUES ('device-owner', '11111111-1111-1111-1111-111111111111',
        'Owner Phone', 'Pixel 8', '14', '1.0.0', 'Google', now(), now());
INSERT INTO public.devices (id, user_id, name, model, os_version, app_version, manufacturer, created_at, updated_at)
VALUES ('device-other', '22222222-2222-2222-2222-222222222222',
        'Other Phone', 'iPhone 15', '17', '1.0.0', 'Apple', now(), now());

-- allowed: owner sees only their own device
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT results_eq(
  $$SELECT id FROM public.devices ORDER BY id$$,
  $$VALUES ('device-owner'::text)$$,
  'allowed: authenticated owner sees only own devices'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: non-owner sees nothing for that row
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('22222222-2222-2222-2222-222222222222');
SELECT is_empty(
  $$SELECT id FROM public.devices WHERE id = 'device-owner'$$,
  'denied: non-owner cannot SELECT another user''s device'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: INSERT ------------------------------------------------------------------
-- denied: cannot insert a device claiming another user's id
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$INSERT INTO public.devices (id, user_id, name, model, os_version, app_version, manufacturer, created_at, updated_at)
    VALUES ('device-spoof', '22222222-2222-2222-2222-222222222222',
            'Spoof', 'X', '0', '0', 'X', now(), now())$$,
  '42501',
  NULL,
  'denied: authenticated cannot INSERT a device for a different user_id'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: UPDATE ------------------------------------------------------------------
-- denied: updating another user's device affects zero rows
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT is_empty(
  $$WITH updated AS (
      UPDATE public.devices SET name = 'hijacked'
      WHERE id = 'device-other'
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
  $$UPDATE public.devices
    SET user_id = '22222222-2222-2222-2222-222222222222'
    WHERE id = 'device-owner'$$,
  '42501',
  NULL,
  'denied: owner cannot UPDATE user_id to another user (WITH CHECK)'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
