BEGIN;
SELECT no_plan();

-- Grants -----------------------------------------------------------------------

SELECT is(
  test_helpers.col_privs('raw_location_data', 'authenticated', 'INSERT'),
  ARRAY['activity_confidence', 'activity_type_id', 'altitude_accuracy',
        'battery_level', 'coordinates_accuracy', 'device_id',
        'ellipsoidal_altitude', 'heading', 'heading_accuracy', 'id',
        'is_device_charging', 'latitude', 'longitude', 'recording_trigger',
        'speed', 'speed_accuracy', 'timestamp', 'user_id'],
  'authenticated can INSERT every column on raw_location_data'
);
SELECT is(
  test_helpers.table_grantees('raw_location_data'),
  ARRAY['authenticated'],
  'authenticated is the only role with table-level privileges'
);
SELECT is(
  test_helpers.all_privs('raw_location_data', 'authenticated'),
  ARRAY['INSERT', 'SELECT', 'UPDATE'],
  'authenticated has exactly INSERT, SELECT, UPDATE privileges'
);

-- RLS: SELECT ------------------------------------------------------------------
-- seed users + one device each + one location reading each
SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

INSERT INTO public.devices (id, user_id, name, model, os_version, app_version, manufacturer, created_at, updated_at)
VALUES ('device-owner', '11111111-1111-1111-1111-111111111111',
        'Owner Phone', 'Pixel 8', '14', '1.0.0', 'Google', now(), now()),
       ('device-other', '22222222-2222-2222-2222-222222222222',
        'Other Phone', 'iPhone 15', '17', '1.0.0', 'Apple', now(), now());

INSERT INTO public.raw_location_data (
  id, user_id, device_id, latitude, longitude, coordinates_accuracy,
  speed, speed_accuracy, heading, heading_accuracy,
  ellipsoidal_altitude, altitude_accuracy, activity_confidence,
  battery_level, is_device_charging, timestamp
) VALUES (
  'loc-owner', '11111111-1111-1111-1111-111111111111', 'device-owner',
  52.5, 13.4, 5, 0, 0, 0, 0, 30, 5, 0.9, 0.8, false, now()
), (
  'loc-other', '22222222-2222-2222-2222-222222222222', 'device-other',
  52.5, 13.4, 5, 0, 0, 0, 0, 30, 5, 0.9, 0.8, false, now()
);

-- allowed: owner sees only their own readings
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT results_eq(
  $$SELECT id FROM public.raw_location_data ORDER BY id$$,
  $$VALUES ('loc-owner'::text)$$,
  'allowed: authenticated owner sees only own location readings'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- denied: non-owner cannot read another user's location data
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('22222222-2222-2222-2222-222222222222');
SELECT is_empty(
  $$SELECT id FROM public.raw_location_data WHERE id = 'loc-owner'$$,
  'denied: non-owner cannot SELECT another user''s location readings'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: INSERT ------------------------------------------------------------------
-- denied: cannot insert a reading attributed to another user
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT throws_ok(
  $$INSERT INTO public.raw_location_data (
      id, user_id, device_id, latitude, longitude, coordinates_accuracy,
      speed, speed_accuracy, heading, heading_accuracy,
      ellipsoidal_altitude, altitude_accuracy, activity_confidence,
      battery_level, is_device_charging, timestamp
    ) VALUES (
      'loc-spoof', '22222222-2222-2222-2222-222222222222', 'device-other',
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, now()
    )$$,
  '42501',
  NULL,
  'denied: authenticated cannot INSERT a reading for a different user_id'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- RLS: UPDATE ------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT is_empty(
  $$WITH updated AS (
      UPDATE public.raw_location_data SET battery_level = 0
      WHERE id = 'loc-other'
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
  $$UPDATE public.raw_location_data
    SET user_id = '22222222-2222-2222-2222-222222222222'
    WHERE id = 'loc-owner'$$,
  '42501',
  NULL,
  'denied: owner cannot UPDATE user_id to another user (WITH CHECK)'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
