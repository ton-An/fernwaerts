import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

/// {@template accept_invite}
/// Accepts an invite for a known server.
///
/// This domain API is reserved for the invite completion flow. The behavior is
/// not implemented yet.
/// {@endtemplate}
class AcceptInvite {
  /// {@macro accept_invite}
  const AcceptInvite();

  /// {@macro accept_invite}
  Future<Either<Failure, None>> call({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }
}
