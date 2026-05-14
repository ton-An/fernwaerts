## Fernwaerts Alpha Definition

Alpha is ready when:

- [ ] A user can run the backend without editing database rows, migrations,
      Supabase Studio internals, or backend files after setup.
- [ ] The app supports the basic account lifecycle: first admin setup, sign in,
      sign out, invite user, invited user setup, password change, email change,
      and clear failure states for common auth errors.
- [ ] The app records and syncs raw background location points with reasonable
      power efficiency.
- [ ] The app derives primitive movement segments from raw points.
- [ ] The main view shows the user's route on the map and lists movement
      segments with primitive POIs for each segment's start and end point.
- [ ] Security-sensitive areas, such as RLS policies and sync rules, are tested
      and hardened.
- [ ] The production self-hosting path is reasonably easy. Target user
      experience: a small user-facing `docker-compose.yml` with one Fernwaerts
      Supabase/PowerSync runtime service, including temporary PowerSync storage,
      and one persistent app Postgres service.
