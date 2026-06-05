import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/settings/domain/usecases/update_email.dart';
import 'package:location_history/features/settings/presentation/cubits/account_settings_cubit/account_settings_state.dart';

/// {@template account_settings_cubit}
/// Coordinates account settings actions that require repository-backed updates.
/// {@endtemplate}
class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  /// {@macro account_settings_cubit}
  AccountSettingsCubit({required this.updateEmailUsecase})
    : super(const AccountSettingsInitial());

  /// Use case that sends the email update verification request.
  final UpdateEmail updateEmailUsecase;

  /// Requests an email update for [newEmail].
  ///
  /// Emits:
  /// - [SendingVerificationEmail] while the request is in flight.
  /// - [VerificationEmailSent] when the verification email was requested.
  /// - [AccountSettingsFailure] when the use case returns a failure.
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
