import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

/// {@template change_password}
/// Changes the current user's password and handles OTP reauthentication.
///
/// If the password update requires reauthentication, the use case requests an
/// OTP and then returns [NeedOtpReauthenticationFailure] so the presentation
/// layer can ask the user for the code before retrying with [otp].
///
/// Parameters:
/// - newPassword: [String] password to set for the current user
/// - otp: [String?] one-time password used for a reauthentication retry
///
/// Failures:
/// - [WeakPasswordFailure]
/// - [NeedOtpReauthenticationFailure]
/// - [PasswordMustDifferFailure]
/// - [OtpInvalidFailure]
/// - [EmailRateLimitFailure]
/// {@macro converted_client_exceptions}
/// {@endtemplate}
class ChangePassword {
  /// {@macro change_password}
  ChangePassword({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  /// {@macro change_password}
  Future<Either<Failure, None>> call({
    required String newPassword,
    String? otp,
  }) async {
    return _changePassword(newPassword: newPassword, otp: otp);
  }

  Future<Either<Failure, None>> _changePassword({
    required String newPassword,
    required String? otp,
  }) async {
    final Either<Failure, None> changePasswordEither = await settingsRepository
        .updatePassword(newPassword: newPassword, otp: otp);

    return changePasswordEither.fold((Failure failure) {
      if (failure is NeedOtpReauthenticationFailure) {
        return _requestOtp(newPassword: newPassword);
      }

      return Left(failure);
    }, Right.new);
  }

  Future<Either<Failure, None>> _requestOtp({
    required String newPassword,
  }) async {
    final Either<Failure, None> reauthenticateEither =
        await settingsRepository.requestOtp();

    return reauthenticateEither.fold(Left.new, (None none) {
      return const Left(NeedOtpReauthenticationFailure());
    });
  }
}
