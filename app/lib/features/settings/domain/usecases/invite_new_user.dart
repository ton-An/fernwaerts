import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

/// {@template invite_new_user}
/// Sends an invitation email for a new Fernwaerts user.
///
/// Parameters:
/// - email: [String] email address of the user to invite
///
/// Failures:
/// - [EmailServerConfigFailure]
/// - [EmailAddressInvalidFailure]
/// - [EmailAddressTakenFailure]
/// - [EmailRateLimitFailure]
/// {@macro converted_client_exceptions}
/// {@macro converted_supabase_functions_exception}
/// {@endtemplate}
class InviteNewUser {
  /// {@macro invite_new_user}
  const InviteNewUser({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  /// {@macro invite_new_user}
  Future<Either<Failure, None>> call({required String email}) async {
    return await settingsRepository.inviteNewUser(email: email);
  }
}
