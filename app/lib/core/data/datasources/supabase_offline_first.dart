// ignore_for_file: public_member_api_docs

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:location_history/brick/brick.g.dart';
import 'package:location_history/brick/db/schema.g.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOfflineFirst
    extends OfflineFirstWithSupabaseRepository<OfflineFirstWithSupabaseModel> {
  SupabaseOfflineFirst._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory SupabaseOfflineFirst() => _singleton!;

  static late SupabaseOfflineFirst? _singleton;

  static Future<void> initializeSupabaseAndConfigure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
    );

    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      httpClient: client,
    );

    final provider = SupabaseProvider(
      supabase.client,
      modelDictionary: supabaseModelDictionary,
    );

    _singleton = SupabaseOfflineFirst._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'my_repository.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }
}
