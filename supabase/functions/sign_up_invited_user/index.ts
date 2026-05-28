import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js";
import validator from "npm:validator";
import type { Database } from "../_shared/database.types.ts";

type Supabase = SupabaseClient<Database>;

Deno.serve(async (request) => {
  const supabase = createClient<Database>(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  const token = request.headers.get("Authorization")?.replace("Bearer ", "");

  const {
    data: { user },
    error: getUserError,
  } = await supabase.auth.getUser(token);

  if (getUserError || !user) {
    return new Response("Unauthorized", { status: 401 });
  }

  const isUserSetUp = await isSetUp(supabase, user.id);

  if (isUserSetUp) {
    return new Response(
      JSON.stringify({
        code: "account_already_set_up",
        message: "Account is already set up.",
      }),
      {
        status: 400,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const { username, password } = await request.json();

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
        code: "weak_password",
        message: "Password is too weak.",
      }),
      {
        status: 400,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  await setUserPassword(supabase, user.id, password);

  await completeDbEntry(supabase, user.id, username);
  await acceptUserRole(supabase, user.id);

  return new Response(null, { status: 200 });
});

async function isSetUp(supabase: Supabase, userId: string) {
  const { data } = await supabase
    .from("users")
    .select("created_at, updated_at")
    .eq("id", userId)
    .single();

  return data !== null && data.updated_at !== data.created_at;
}

async function setUserPassword(
  supabase: Supabase,
  userId: string,
  password: string,
) {
  await supabase.auth.admin.updateUserById(userId, {
    password,
  });
}

async function completeDbEntry(
  supabase: Supabase,
  userId: string,
  username: string,
) {
  await supabase
    .from("users")
    .update({ username: username })
    .eq("id", userId);
}

async function acceptUserRole(supabase: Supabase, userId: string) {
  await supabase
    .from("user_roles")
    .update({ accepted_at: new Date().toISOString() })
    .eq("user_id", userId)
    .is("accepted_at", null);
}
