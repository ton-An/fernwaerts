import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/expired_refresh_token_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template recover_invite_session}
/// Recovers the temporary auth session from a valid invite link.
///
/// Parameters:
/// - refreshToken: [String] refresh token from the Supabase invite callback
///
/// Failures:
/// - [ExpiredRefreshTokenFailure]
/// {@macro converted_client_exceptions}
/// {@endtemplate}
class RecoverInviteSession {
  /// {@macro recover_invite_session}
  const RecoverInviteSession({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro recover_invite_session}
  Future<Either<Failure, None>> call({required String refreshToken}) {
    return authenticationRepository.recoverInviteSession(
      refreshToken: refreshToken,
    );
  }
}
