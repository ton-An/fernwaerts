BEGIN;
SELECT no_plan();

-- has_permission(requested_permission) returns true iff the caller (auth.uid())
-- has an accepted, undeleted user_role whose role grants the requested permission.
-- Seed data: admin role grants read.users + write.users.

SELECT test_helpers.create_user('11111111-1111-1111-1111-111111111111');
SELECT test_helpers.create_user('22222222-2222-2222-2222-222222222222');

-- Case 1: accepted admin role → true ------------------------------------------
INSERT INTO public.user_roles (id, user_id, role, accepted_at)
VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '11111111-1111-1111-1111-111111111111', 'admin', now());

SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT ok(
  public.has_permission('read.users'),
  'accepted admin → has_permission(read.users) is true'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- Case 2: pending role (accepted_at IS NULL) → false --------------------------
UPDATE public.user_roles SET accepted_at = NULL
WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT ok(
  NOT public.has_permission('read.users'),
  'pending role → has_permission(read.users) is false'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- Case 3: accepted but soft-deleted role → false ------------------------------
UPDATE public.user_roles SET accepted_at = now(), deleted_at = now()
WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('11111111-1111-1111-1111-111111111111');
SELECT ok(
  NOT public.has_permission('read.users'),
  'deleted role → has_permission(read.users) is false'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- Case 4: user has no role at all → false -------------------------------------
SET LOCAL ROLE authenticated;
SELECT test_helpers.set_actor('22222222-2222-2222-2222-222222222222');
SELECT ok(
  NOT public.has_permission('read.users'),
  'missing role → has_permission(read.users) is false'
);
RESET ROLE; SELECT test_helpers.reset_actor();

-- ------------------------------------------------------------------------------
SELECT * FROM finish();
ROLLBACK;
