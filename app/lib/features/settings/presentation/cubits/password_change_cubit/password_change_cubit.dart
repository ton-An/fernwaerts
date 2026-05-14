import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/usecases/change_password.dart';
import 'package:location_history/features/settings/presentation/cubits/password_change_cubit/password_change_states.dart';

/// {@template password_change_cubit}
/// Coordinates password change requests from the settings UI.
/// {@endtemplate}
class PasswordChangeCubit extends Cubit<PasswordChangeState> {
  /// {@macro password_change_cubit}
  PasswordChangeCubit({required this.changePasswordUseCase})
    : super(const PasswordChangeInitial());

  /// Use case that updates the user's password.
  final ChangePassword changePasswordUseCase;

  /// Attempts to change the password to [newPassword].
  ///
  /// [otp] is forwarded when the server requires OTP reauthentication.
  ///
  /// Emits:
  /// - [PasswordChangeLoading] while the request is in flight.
  /// - [PasswordChangeSuccess] when the password was changed.
  /// - [PasswordChangeFailure] when the use case returns a failure.
  void changePassword({required String newPassword, String? otp}) async {
    emit(const PasswordChangeLoading());

    final Either<Failure, None> changePasswordEither =
        await changePasswordUseCase(newPassword: newPassword, otp: otp);

    changePasswordEither.fold(
      (failure) => emit(PasswordChangeFailure(failure: failure)),
      (_) => emit(const PasswordChangeSuccess()),
    );
  }
}
