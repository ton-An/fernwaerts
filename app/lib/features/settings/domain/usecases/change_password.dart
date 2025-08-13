import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

class ChangePassword {
  ChangePassword({required this.settingsRepository});

  final SettingsRepository settingsRepository;

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
