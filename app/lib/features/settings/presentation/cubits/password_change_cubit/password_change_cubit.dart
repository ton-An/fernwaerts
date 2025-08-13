import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/usecases/change_password.dart';
import 'package:location_history/features/settings/presentation/cubits/password_change_cubit/password_change_states.dart';

class PasswordChangeCubit extends Cubit<PasswordChangeState> {
  PasswordChangeCubit({required this.changePasswordUseCase})
    : super(const PasswordChangeInitial());

  final ChangePassword changePasswordUseCase;

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
