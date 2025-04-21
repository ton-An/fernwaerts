import 'package:location_history/core/data/datasources/supabase_offline_first.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  const SupabaseHandler();

  SupabaseClient getClient() => Supabase.instance.client;

  Future<void> initialize({required ServerInfo serverInfo}) async {
    await SupabaseOfflineFirst.initializeSupabaseAndConfigure(
      supabaseUrl: serverInfo.url,
      supabaseAnonKey: serverInfo.anonKey,
    );

    await SupabaseOfflineFirst().initialize();
  }

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
