import "jsr:@supabase/functions-js/edge-runtime.d.ts";

Deno.serve(() => {
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
