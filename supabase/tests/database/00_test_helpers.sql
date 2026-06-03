-- Helper functions for pgTAP grant/privilege assertions.
-- Loaded automatically before test files by pg_prove (alphabetical order).
-- Do NOT add \ir for this file in test files.
SELECT plan(1);

CREATE SCHEMA IF NOT EXISTS test_helpers;

-- Returns sorted columns a role has the given privilege type on (e.g. 'INSERT', 'SELECT').
CREATE OR REPLACE FUNCTION test_helpers.col_privs(p_table text, p_role text, p_priv text)
RETURNS text[] LANGUAGE sql STABLE AS $$
  SELECT coalesce(array_agg(column_name::text ORDER BY column_name), ARRAY[]::text[])
  FROM information_schema.column_privileges
  WHERE table_schema    = 'public'
    AND table_name      = p_table
    AND grantee         = p_role
    AND privilege_type  = p_priv;
$$;

-- Returns sorted grantees that hold any table-level privilege, excluding postgres,
-- PUBLIC, and Supabase/PowerSync system roles. Only client-facing roles that the
-- application explicitly grants to (anon, authenticated) should appear.
CREATE OR REPLACE FUNCTION test_helpers.table_grantees(p_table text)
RETURNS text[] LANGUAGE sql STABLE AS $$
  SELECT coalesce(array_agg(grantee ORDER BY grantee), ARRAY[]::text[])
  FROM (
    SELECT DISTINCT grantee::text
    FROM information_schema.table_privileges
    WHERE table_schema = 'public'
      AND table_name   = p_table
      AND grantee NOT IN ('postgres', 'PUBLIC', 'service_role',
                          'supabase_admin', 'supabase_auth_admin',
                          'supabase_storage_admin', 'supabase_replication_admin',
                          'dashboard_user', 'pgsodium_keyiduser', 'pgsodium_keyholder',
                          'pgsodium_keymaker', 'powersync_role')
  ) t;
$$;

-- Returns sorted distinct privilege types a role holds on a table (table-level + column-level combined).
CREATE OR REPLACE FUNCTION test_helpers.all_privs(p_table text, p_role text)
RETURNS text[] LANGUAGE sql STABLE AS $$
  SELECT coalesce(array_agg(privilege_type ORDER BY privilege_type), ARRAY[]::text[])
  FROM (
    SELECT DISTINCT privilege_type::text
    FROM (
      SELECT privilege_type FROM information_schema.table_privileges
      WHERE table_schema = 'public' AND table_name = p_table AND grantee = p_role
      UNION
      SELECT privilege_type FROM information_schema.column_privileges
      WHERE table_schema = 'public' AND table_name = p_table AND grantee = p_role
    ) raw
  ) combined;
$$;

-- Simulate an authenticated user by setting the JWT claims so auth.uid() returns p_user_id.
-- Use before SET LOCAL ROLE authenticated; reset with reset_actor().
CREATE OR REPLACE FUNCTION test_helpers.set_actor(p_user_id uuid)
RETURNS void LANGUAGE sql AS $$
  SELECT set_config('request.jwt.claims',
    format('{"sub": "%s", "role": "authenticated"}', p_user_id),
    true);
$$;

-- Clear JWT claims after a role-scoped test block.
CREATE OR REPLACE FUNCTION test_helpers.reset_actor()
RETURNS void LANGUAGE sql AS $$
  SELECT set_config('request.jwt.claims', '{}', true);
$$;

-- Insert minimal auth.users + public.users rows for a test fixture user.
-- Idempotent so a single test can call it for the same uuid more than once.
CREATE OR REPLACE FUNCTION test_helpers.create_user(p_user_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  v_email text := p_user_id::text || '@test.local';
BEGIN
  INSERT INTO auth.users (id, instance_id, aud, role, email)
  VALUES (p_user_id, '00000000-0000-0000-0000-000000000000',
          'authenticated', 'authenticated', v_email)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.users (id, email, username)
  VALUES (p_user_id, v_email, p_user_id::text)
  ON CONFLICT (id) DO NOTHING;
END;
$$;

-- Allow authenticated callers to set their own JWT claims during a test block.
GRANT USAGE ON SCHEMA test_helpers TO authenticated, anon;
GRANT EXECUTE ON FUNCTION test_helpers.set_actor(uuid) TO authenticated, anon;
GRANT EXECUTE ON FUNCTION test_helpers.reset_actor() TO authenticated, anon;

SELECT pass('test_helpers loaded');
SELECT * FROM finish();
