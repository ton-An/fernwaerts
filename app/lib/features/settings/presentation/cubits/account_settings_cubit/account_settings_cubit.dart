import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/settings/domain/usecases/update_email.dart';
import 'package:location_history/features/settings/presentation/cubits/account_settings_cubit/account_settings_states.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit({required this.updateEmailUsecase})
    : super(const AccountSettingsLoading());

  final UpdateEmail updateEmailUsecase;

  User? _user;

  Future<void> loadUserData() async {
    await Future.delayed(const Duration(seconds: 1));

    _user = const User(
      id: 'id',
      username: 'username',
      email: 'anton@antons-webfabrik.eu',
    );

    emit(AccountSettingsInitialLoaded(user: _user!));
  }

  Future<void> updateEmail(String newEmail) async {
    if (_user == null) {
      return;
    }

    emit(AccountSettingsUpdating(user: _user!));

    final Either<Failure, None> updateEmailEither = await updateEmailUsecase(
      newEmail: newEmail,
    );

    updateEmailEither.fold(
      (failure) {
        emit(AccountSettingsFailure(failure: failure));
      },
      (None none) {
        _user = _user!.copyWith(email: newEmail);

        emit(AccountSettingsUpdated(user: _user!));
      },
    );
  }
}
