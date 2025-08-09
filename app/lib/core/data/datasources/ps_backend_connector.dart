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

  Future<void>? _refreshFuture;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    await _refreshFuture;

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return null;
    }

    final token = session.accessToken;

    final userId = session.user.id;
    final expiresAt =
        session.expiresAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
    return PowerSyncCredentials(
      endpoint: powersyncUrl,
      token: token,
      userId: userId,
      expiresAt: expiresAt,
    );
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync.
    // Generally, sessions should be refreshed automatically by Supabase.
    // However, in some cases it can be a while before the session refresh is
    // retried. We attempt to trigger the refresh as soon as we get an auth
    // failure on PowerSync.
    //
    // This could happen if the device was offline for a while and the session
    // expired, and nothing else attempt to use the session it in the meantime.
    //
    // Timeout the refresh call to avoid waiting for long retries,
    // and ignore any errors. Errors will surface as expired tokens.
    _refreshFuture = Supabase.instance.client.auth
        .refreshSession()
        .timeout(const Duration(seconds: 5))
        .then((response) => null, onError: (error) => null);
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
