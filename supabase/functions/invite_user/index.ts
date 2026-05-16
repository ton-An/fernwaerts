import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "npm:@supabase/supabase-js@2";

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

  const isUserAdmin = await isAdmin(supabase, user?.id);

  if (getUserError || !user || !isUserAdmin) {
    return new Response("Unauthorized", { status: 401 });
  }

  const siteUrl = Deno.env.get("SITE_URL");
  const apiUrl = Deno.env.get("API_EXTERNAL_URL");

  if (!siteUrl) {
    throw new Error("Missing SITE_URL environment variable");
  }

  if (!apiUrl) {
    throw new Error("Missing API_EXTERNAL_URL environment variable");
  }

  const { email: newUserEmail } = await request.json();

  return await inviteNewUser(supabase, siteUrl, apiUrl, newUserEmail);
});

async function deleteUser(supabase: SupabaseClient, userId: string) {
  await supabase.from("users").delete().eq("id", userId);

  await supabase.auth.admin.deleteUser(
    userId,
  );
}

async function inviteNewUser(
  supabase: SupabaseClient,
  siteUrl: string,
  apiUrl: string,
  email: string,
) {
  console.log("inviteNewUser", email);
  const redirectTo = `${siteUrl}/sign-up-invite?serverUrl=${apiUrl}`;

  const { data: newUser, error: inviteError } = await supabase.auth.admin
    .inviteUserByEmail(email, {
      redirectTo: redirectTo,
    });

  console.log("newUser", newUser);
  console.log("inviteError", inviteError);

  if (inviteError) {
    const errorCode = inviteError?.code;

    if (errorCode == "email_exists") {
      const user = await getUserByEmail(supabase, email);

      if (user && !user.is_setup) {
        await deleteUser(supabase, user.id);

        return await inviteNewUser(supabase, siteUrl, apiUrl, email);
      }
    }

    return new Response(
      JSON.stringify({
        code: errorCode,
        message: inviteError?.message,
      }),
      {
        status: inviteError?.status ?? 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  await addUserToDB(supabase, newUser.user.id, newUser.user.email);

  return new Response(null, {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
}

async function isAdmin(supabase: SupabaseClient, userId?: string) {
  const { data: roles } = await supabase
    .from("user_roles")
    .select()
    .eq("user_id", userId);

  return roles?.some((role) => role.role === "admin");
}

async function getUserByEmail(supabase: SupabaseClient, email?: string) {
  const { data: users } = await supabase
    .from("users")
    .select()
    .eq("email", email)
    .limit(1);

  const user = users?.[0];

  return user;
}

async function addUserToDB(
  supabase: SupabaseClient,
  userId: string,
  email?: string,
) {
  await supabase.from("users").insert({
    id: userId,
    username: null,
    email: email,
    is_set_up: false,
  });
}
