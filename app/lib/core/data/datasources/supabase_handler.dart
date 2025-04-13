import 'package:location_history/core/data/datasources/supabase_offline_first.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  const SupabaseHandler();

  SupabaseClient getClient() => Supabase.instance.client;

  Future<void> initialize({required String serverUrl}) async {
    await SupabaseOfflineFirst.initializeSupabaseAndConfigure(
      supabaseUrl: serverUrl,
      supabaseAnonKey: '',
    );

    await SupabaseOfflineFirst().initialize();
  }

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
