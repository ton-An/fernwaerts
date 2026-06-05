import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

/// {@template update_email}
/// Updates the email address of the current user.
///
/// Parameters:
/// - newEmail: [String] new email address to update to
///
/// Failures:
/// - [EmailServerConfigFailure]
/// - [EmailAddressInvalidFailure]
/// - [EmailAddressTakenFailure]
/// - [EmailRateLimitFailure]
/// {@macro converted_client_exceptions}
/// {@endtemplate}
class UpdateEmail {
  /// {@macro update_email}
  UpdateEmail({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  /// {@macro update_email}
  Future<Either<Failure, None>> call({required String newEmail}) {
    return settingsRepository.updateEmail(newEmail: newEmail);
  }
}
