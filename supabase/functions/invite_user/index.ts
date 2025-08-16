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

  const isUserAdmin = isAdmin(supabase, user?.id);

  if (getUserError || !user || !isUserAdmin) {
    return new Response("Unauthorized", { status: 401 });
  }

  const siteUrl = Deno.env.get("SITE_URL");

  if (!siteUrl) {
    throw new Error("Missing SITE_URL environment variable");
  }

  const { email: newUserEmail } = await request.json();

  const { data: newUser, error: inviteError } = await supabase.auth.admin
    .inviteUserByEmail(newUserEmail, {
      redirectTo: `${siteUrl}/sign-up-invite`,
    });

  if (inviteError) {
    const errorCode = inviteError?.code;

    if (errorCode == "email_exists") {
      const user = await getUserByEmail(supabase, newUserEmail);

      if (user && !user.is_setup) {
        const { error: reinviteNewUserError } = await supabase.auth.resend({
          type: "signup",
          email: newUserEmail!,
        });

        if (reinviteNewUserError) {
          return new Response(
            JSON.stringify({
              code: reinviteNewUserError?.code,
              message: reinviteNewUserError?.message,
            }),
            {
              status: reinviteNewUserError?.status ?? 500,
              headers: { "Content-Type": "application/json" },
            },
          );
        }
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
});

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
