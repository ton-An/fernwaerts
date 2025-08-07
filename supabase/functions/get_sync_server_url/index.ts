import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

Deno.serve(async (request) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  const token = request.headers.get("Authorization")?.replace("Bearer ", "");

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser(token);

  if (error || !user) {
    return new Response("Unauthorized", { status: 401 });
  }

  const syncServerUrl = Deno.env.get("POWERSYNC_URL");

  if (!syncServerUrl) {
    throw new Error("Missing POWERSYNC_URL environment variable");
  }

  return new Response(
    JSON.stringify({ "data": { "sync_server_url": syncServerUrl } }),
    {
      status: 200,
      headers: { "Content-Type": "application/json" },
    },
  );
});
