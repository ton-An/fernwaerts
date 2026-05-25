import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js";
import validator from "npm:validator";
import type { Database } from "../_shared/database.types.ts";

type Supabase = SupabaseClient<Database>;

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  const { username, email, password } = await req.json();

  const supabaseClient = Deno.env.get("SUPABASE_CLIENT") ??
    Deno.env.get("SUPABASE_URL");
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseClient || !supabaseKey) {
    throw new Error("Missing Supabase environment variables");
  }

  const supabase = createClient<Database>(supabaseClient, supabaseKey);

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
        error: { code: "weak_password" },
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
  supabase: Supabase,
  email: string,
  password: string,
): Promise<string> {
  // TODO: Handle errors
  const { data } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  return data.user!.id;
}

async function isSetUp(supabase: Supabase): Promise<boolean> {
  const { data } = await supabase
    .from("public_info")
    .select()
    .eq("name", "is_set_up")
    .single();

  return data?.value === true;
}

async function addUserToDB(
  supabase: Supabase,
  userId: string,
  username: string,
  email: string,
) {
  // Different timestamps to ensure updated_at is after created_at, which means that the user is set up
  const now = new Date();
  const nowIncremented = new Date(now.getTime() + 1000);

  await supabase.from("users").insert({
    id: userId,
    username: username,
    email: email,
    created_at: now.toISOString(),
    updated_at: nowIncremented.toISOString(),
  });
}

async function makeUserAdmin(supabase: Supabase, userId: string) {
  await supabase.from("user_roles").insert({
    user_id: userId,
    role: "admin",
  });
}

async function markSetupAsComplete(supabase: Supabase) {
  await supabase
    .from("public_info")
    .update({
      value: true,
    })
    .eq("name", "is_set_up");
}
