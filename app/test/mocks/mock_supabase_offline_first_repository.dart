import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_supabase/testing.dart';
import 'package:location_history/brick/brick.g.dart';
import 'package:location_history/brick/db/schema.g.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseOfflineFirstRepository
    extends OfflineFirstWithSupabaseRepository {
  MockSupabaseOfflineFirstRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  }) : super(migrations: {const Migration20250509102604()});

  factory MockSupabaseOfflineFirstRepository.configure({
    required SupabaseMockServer mockSupabaseServer,
  }) {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactoryFfi,
      reattemptForStatusCodes: [],
    );

    final provider = SupabaseProvider(
      SupabaseClient(
        mockSupabaseServer.serverUrl,
        mockSupabaseServer.apiKey,
        httpClient: client,
      ),
      modelDictionary: supabaseModelDictionary,
    );

    return MockSupabaseOfflineFirstRepository._(
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'my_repository.sqlite',
        databaseFactory: databaseFactoryFfi,
        modelDictionary: sqliteModelDictionary,
      ),
    );
  }
}
