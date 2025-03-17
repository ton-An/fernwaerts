import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

/*
  To-Do:
    - [ ] Write unit tests
    - [ ] Add error handling
    - [ ] Find a better way to check if server is already set up (like a db entry)
    - [ ] Standardize constants
*/

Deno.serve(async (req) => {
  if (req.method !== "GET") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      {
        status: 405,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const supabaseClient = Deno.env.get("SUPABASE_CLIENT") ??
    Deno.env.get("SUPABASE_URL");
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseClient || !supabaseKey) {
    throw new Error("Missing Supabase environment variables");
  }

  const supabase = createClient(supabaseClient, supabaseKey);

  const { data: { users } } = await supabase.auth.admin.listUsers({
    page: 1,
    perPage: 1,
  });

  const isSetupComplete = users !== null && users.length > 0;

  return new Response(
    JSON.stringify({
      data: { is_set_up_complete: isSetupComplete },
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});
