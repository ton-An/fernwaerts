import 'dart:async';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:location_history/core/data/datasources/supabase_offline_first.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  SupabaseHandler();

  final Completer<SupabaseClient> _clientCompleter =
      Completer<SupabaseClient>();

  final Completer<OfflineFirstWithSupabaseRepository> _offlineFirstCompleter =
      Completer<OfflineFirstWithSupabaseRepository>();

  Future<SupabaseClient> get client {
    if (_clientCompleter.isCompleted) {
      return Future.value(Supabase.instance.client);
    } else {
      return _clientCompleter.future;
    }
  }

  Future<OfflineFirstWithSupabaseRepository> get supabaseOfflineFirst {
    if (_clientCompleter.isCompleted) {
      return Future.value(SupabaseOfflineFirst());
    } else {
      return _offlineFirstCompleter.future;
    }
  }

  Future<void> initialize({required ServerInfo serverInfo}) async {
    await SupabaseOfflineFirst.initializeSupabaseAndConfigure(
      supabaseUrl: serverInfo.url,
      supabaseAnonKey: serverInfo.anonKey,
    );

    await SupabaseOfflineFirst().initialize();

    if (!_offlineFirstCompleter.isCompleted) {
      _offlineFirstCompleter.complete(SupabaseOfflineFirst());
    }
    if (!_clientCompleter.isCompleted) {
      _clientCompleter.complete(Supabase.instance.client);
    }
  }

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
