import 'dart:async';

import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:location_history/core/data/datasources/ps_backend_connector.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/core/drift/schema.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  SupabaseHandler();

  final Completer<SupabaseClient> _clientCompleter =
      Completer<SupabaseClient>();

  final Completer<PsBackendConnector> _psBackendConnectorCompleter =
      Completer<PsBackendConnector>();

  final Completer<DriftAppDatabase> _driftDatabaseCompleter =
      Completer<DriftAppDatabase>();

  late final DriftAppDatabase _driftDatabase;

  Future<SupabaseClient> get client {
    if (_clientCompleter.isCompleted) {
      return Future.value(Supabase.instance.client);
    } else {
      return _clientCompleter.future;
    }
  }

  Future<PsBackendConnector> get psBackendConnector {
    if (_psBackendConnectorCompleter.isCompleted) {
      return Future.value(PsBackendConnector());
    } else {
      return _psBackendConnectorCompleter.future;
    }
  }

  Future<DriftAppDatabase> get driftDatabase {
    if (_driftDatabaseCompleter.isCompleted) {
      return Future.value(_driftDatabase);
    } else {
      return _driftDatabaseCompleter.future;
    }
  }

  Future<void> initializeSupabase({required SupabaseInfo supabaseInfo}) async {
    final Supabase supabase = await Supabase.initialize(
      url: supabaseInfo.url,
      anonKey: supabaseInfo.anonKey,
    );

    if (!_clientCompleter.isCompleted) {
      _clientCompleter.complete(supabase.client);
    }
  }

  Future<void> initializePowerSync({
    required PowersyncInfo powersyncInfo,
  }) async {
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, 'powersync-dart.db');

    PowerSyncDatabase powersyncDb = PowerSyncDatabase(
      schema: schema,
      path: path,
    );

    final SupabaseClient supabaseClient = Supabase.instance.client;

    PsBackendConnector psBackendConnector = PsBackendConnector.init(
      supabaseClient: supabaseClient,
      powersyncUrl: powersyncInfo.url,
    );

    powersyncDb.connect(connector: psBackendConnector);

    _driftDatabase = DriftAppDatabase(SqliteAsyncDriftConnection(powersyncDb));

    if (!_psBackendConnectorCompleter.isCompleted) {
      _psBackendConnectorCompleter.complete(psBackendConnector);
    }

    if (!_driftDatabaseCompleter.isCompleted) {
      _driftDatabaseCompleter.complete(_driftDatabase);
    }

    await psBackendConnector.uploadData(powersyncDb);
  }

  Future<void> dispose() async {
    await Supabase.instance.dispose();
  }
}
