import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/* 
  To-Do:
    - [ ] add error handling (e.g. to uploadData)
    - [ ] add proper implementation of upload data
    - [ ] add expired token handling (https://github.com/powersync-ja/powersync.dart/blob/main/demos/supabase-todolist/lib/powersync.dart)
    - [ ] add user not logged in
    - [ ] surface error from this class in the ui. (probably like: last sync was x days ago)
*/

class PsBackendConnector extends PowerSyncBackendConnector {
  PsBackendConnector._({
    required this.supabaseClient,
    required this.powersyncUrl,
  });

  factory PsBackendConnector() => _singleton!;

  factory PsBackendConnector.init({
    required SupabaseClient supabaseClient,
    required String powersyncUrl,
  }) =>
      _singleton ??= PsBackendConnector._(
        supabaseClient: supabaseClient,
        powersyncUrl: powersyncUrl,
      );

  static PsBackendConnector? _singleton;

  final SupabaseClient supabaseClient;
  final String powersyncUrl;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final String? token = supabaseClient.auth.currentSession?.accessToken;

    if (token == null) {
      return null;
    }

    return PowerSyncCredentials(
      endpoint: powersyncUrl,
      token: supabaseClient.auth.currentSession!.accessToken,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.
    final transaction = await database.getNextCrudTransaction();

    if (transaction == null) {
      return;
    }

    final rest = Supabase.instance.client.rest;

    // Note: If transactional consistency is important, use database functions
    // or edge functions to process the entire transaction in a single call.
    for (var op in transaction.crud) {
      final table = rest.from(op.table);
      if (op.op == UpdateType.put) {
        var data = Map<String, dynamic>.of(op.opData!);
        data['id'] = op.id;
        await table.upsert(data);
      } else if (op.op == UpdateType.patch) {
        await table.update(op.opData!).eq('id', op.id);
      } else if (op.op == UpdateType.delete) {
        await table.delete().eq('id', op.id);
      }

      // All operations successful.
      await transaction.complete();
    }
  }
}
