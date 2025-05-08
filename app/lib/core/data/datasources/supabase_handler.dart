import 'dart:async';

import 'package:location_history/core/data/datasources/supabase_offline_first.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  SupabaseHandler();

  final Completer<SupabaseClient> _clientCompleter =
      Completer<SupabaseClient>();

  final Completer<SupabaseOfflineFirst> _offlineFirstCompleter =
      Completer<SupabaseOfflineFirst>();

  Future<SupabaseClient> get client => _clientCompleter.future;

  Future<SupabaseOfflineFirst> get supabaseOfflineFirst =>
      _offlineFirstCompleter.future;

  Future<void> initialize({required ServerInfo serverInfo}) async {
    await SupabaseOfflineFirst.initializeSupabaseAndConfigure(
      supabaseUrl: serverInfo.url,
      supabaseAnonKey: serverInfo.anonKey,
    );

    await SupabaseOfflineFirst().initialize();

    _offlineFirstCompleter.complete(SupabaseOfflineFirst());
    _clientCompleter.complete(Supabase.instance.client);
  }

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
