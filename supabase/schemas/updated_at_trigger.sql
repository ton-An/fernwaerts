create extension if not exists "moddatetime" with schema "extensions";

create trigger handle_updated_at before update on public.devices for each row execute function extensions.moddatetime ('updated_at');
create trigger handle_updated_at before update on public.user_roles for each row execute function extensions.moddatetime ('updated_at');
create trigger handle_updated_at before update on public.users for each row execute function extensions.moddatetime ('updated_at');