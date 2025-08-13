import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/usecases/update_email.dart';
import 'package:location_history/features/settings/presentation/cubits/account_settings_cubit/account_settings_states.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit({required this.updateEmailUsecase})
    : super(const AccountSettingsInitial());

  final UpdateEmail updateEmailUsecase;

  Future<void> updateEmail(String newEmail) async {
    emit(const SendingVerificationEmail());

    final Either<Failure, None> updateEmailEither = await updateEmailUsecase(
      newEmail: newEmail,
    );

    updateEmailEither.fold(
      (failure) {
        emit(AccountSettingsFailure(failure: failure));
      },
      (None none) {
        emit(const VerificationEmailSent());
      },
    );
  }
}
