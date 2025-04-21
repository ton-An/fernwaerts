import "jsr:@supabase/functions-js/edge-runtime.d.ts";

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

  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

  if (!anonKey) {
    throw new Error("Missing Supabase environment variables");
  }

  return new Response(JSON.stringify({ "data": { "anon_key": anonKey } }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
});
