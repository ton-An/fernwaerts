import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  const SupabaseHandler();

  SupabaseClient getClient() => Supabase.instance.client;

  Future<Supabase> initialize({required String serverUrl}) =>
      Supabase.initialize(url: serverUrl, anonKey: "");

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
