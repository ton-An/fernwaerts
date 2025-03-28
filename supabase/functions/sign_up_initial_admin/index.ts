import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js";
import validator from "npm:validator";

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      {
        status: 405,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const { username, email, password } = await req.json();

  const supabaseClient = Deno.env.get("SUPABASE_CLIENT") ??
    Deno.env.get("SUPABASE_URL");
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseClient || !supabaseKey) {
    throw new Error("Missing Supabase environment variables");
  }

  const supabase = createClient(supabaseClient, supabaseKey);

  if (await isSetUp(supabase)) {
    return new Response(null, {
      status: 400,
    });
  }

  const isValidPassword = validator.isStrongPassword(password, {
    minLength: 8,
    minLowercase: 1,
    minUppercase: 1,
    minNumbers: 1,
    minSymbols: 1,
  });

  if (!isValidPassword) {
    return new Response(
      JSON.stringify({
        error: { "code": "weak_password" },
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const userId = await createUserAccount(supabase, email, password);

  await addUserToDB(supabase, userId, username, email);

  await makeUserAdmin(supabase, userId);

  await markSetupAsComplete(supabase);

  return new Response();
});

async function createUserAccount(
  supabase: SupabaseClient,
  email: string,
  password: string,
): Promise<string> {
  const { data } = await supabase.auth.admin.createUser({
    email,
    password,
  });

  return data.user?.id;
}

async function isSetUp(supabase: SupabaseClient): Promise<boolean> {
  const { data } = await supabase.from("public_settings")
    .select().eq(
      "name",
      "is_set_up",
    ).single();

  return data.value;
}

async function addUserToDB(
  supabase: SupabaseClient,
  userId: string,
  username: string,
  email: string,
) {
  await supabase.from("users").insert({
    id: userId,
    username: username,
    email: email,
  });
}

async function makeUserAdmin(
  supabase: SupabaseClient,
  userId: string,
) {
  await supabase.from("user_roles").insert({
    user_id: userId,
    role: "admin",
  });
}

async function markSetupAsComplete(supabase: SupabaseClient) {
  await supabase.from("public_settings").update({
    value: true,
  }).eq(
    "name",
    "is_set_up",
  );
}
