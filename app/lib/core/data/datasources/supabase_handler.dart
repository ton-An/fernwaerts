import 'dart:async';

import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:location_history/core/data/datasources/ps_backend_connector.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/core/drift/schema.dart';
import 'package:location_history/core/misc/app_file_constants.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  To-Do:
    - [ ] fix late already initialized exception
*/

/// {@template supabase_handler}
/// Initializes and exposes the app-wide Supabase and PowerSync-backed Drift
/// clients.
///
/// Supabase and PowerSync are configured after the user provides or loads server
/// connection details. Consumers await [client] or [driftDatabase] instead of
/// assuming these dependencies are available during app startup.
/// {@endtemplate}
class SupabaseHandler {
  /// {@macro supabase_handler}
  SupabaseHandler();

  final Completer<SupabaseClient> _clientCompleter =
      Completer<SupabaseClient>();

  final Completer<DriftAppDatabase> _driftDatabaseCompleter =
      Completer<DriftAppDatabase>();

  late final DriftAppDatabase _driftDatabase;

  /// The initialized Supabase client.
  ///
  /// Returns immediately after Supabase has been initialized, otherwise waits
  /// for [initializeSupabase] to complete.
  Future<SupabaseClient> get client {
    if (_clientCompleter.isCompleted) {
      return Future.value(Supabase.instance.client);
    } else {
      return _clientCompleter.future;
    }
  }

  /// The initialized Drift database backed by PowerSync.
  ///
  /// Returns immediately after PowerSync has been initialized, otherwise waits
  /// for [initializePowerSync] to complete.
  Future<DriftAppDatabase> get driftDatabase {
    if (_driftDatabaseCompleter.isCompleted) {
      return Future.value(_driftDatabase);
    } else {
      return _driftDatabaseCompleter.future;
    }
  }

  /// Initializes Supabase with the saved or newly entered server connection.
  ///
  /// Parameters:
  /// - supabaseInfo: [SupabaseInfo] Supabase URL and anon key.
  Future<void> initializeSupabase({required SupabaseInfo supabaseInfo}) async {
    final Supabase supabase = await Supabase.initialize(
      url: supabaseInfo.url,
      anonKey: supabaseInfo.anonKey,
    );

    if (!_clientCompleter.isCompleted) {
      _clientCompleter.complete(supabase.client);
    }
  }

  /// Initializes PowerSync and exposes the Drift database over its SQLite file.
  ///
  /// Parameters:
  /// - powersyncInfo: [PowersyncInfo] PowerSync endpoint configuration.
  Future<void> initializePowerSync({
    required PowersyncInfo powersyncInfo,
  }) async {
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, AppFileConstants.sqliteDbFileName);

    PowerSyncDatabase powersyncDb = PowerSyncDatabase(
      schema: schema,
      path: path,
    );

    final SupabaseClient supabaseClient = Supabase.instance.client;

    PsBackendConnector psBackendConnector = PsBackendConnector.init(
      supabaseClient: supabaseClient,
      powersyncUrl: powersyncInfo.url,
    );

    await powersyncDb.connect(connector: psBackendConnector);

    _driftDatabase = DriftAppDatabase(SqliteAsyncDriftConnection(powersyncDb));

    if (!_driftDatabaseCompleter.isCompleted) {
      _driftDatabaseCompleter.complete(_driftDatabase);
    }
  }

  /// Disposes the global Supabase instance.
  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
