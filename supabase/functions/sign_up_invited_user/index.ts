import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js";
import validator from "npm:validator";

Deno.serve(async (request) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  const token = request.headers.get("Authorization")?.replace("Bearer ", "");

  const {
    data: { user },
    error: getUserError,
  } = await supabase.auth.getUser(token);

  const isUserSetUp = await isSetUp(supabase, user?.id);

  if (getUserError || !user || isUserSetUp) {
    return new Response(
      JSON.stringify({
        error: { code: "account_already_set_up" },
      }),
      { status: 400 },
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
        error: { code: "weak_password" },
      }),
      {
        status: 400,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  await setUserPassword(supabase, user.id, password);

  await completeDbEntry(supabase, user.id, username);

  return new Response(null, { status: 200 });
});

async function isSetUp(supabase: SupabaseClient, userId: string) {
  const { data } = await supabase
    .from("users")
    .select("is_set_up")
    .eq("id", userId)
    .single();

  return data?.is_set_up;
}

async function setUserPassword(
  supabase: SupabaseClient,
  userId: string,
  password: string,
) {
  await supabase.auth.admin.updateUserById(userId, {
    password,
  });
}

async function completeDbEntry(
  supabase: SupabaseClient,
  userId: string,
  username: string,
) {
  await supabase
    .from("users")
    .update({ username: username, is_set_up: true })
    .eq("id", userId);
}
