import 'package:equatable/equatable.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class AccountSettingsState extends Equatable {
  const AccountSettingsState();

  @override
  List<Object> get props => [];
}

class AccountSettingsInitial extends AccountSettingsState {
  const AccountSettingsInitial();
}

class SendingVerificationEmail extends AccountSettingsState {
  const SendingVerificationEmail();
}

class VerificationEmailSent extends AccountSettingsState {
  const VerificationEmailSent();
}

class AccountSettingsFailure extends AccountSettingsState {
  const AccountSettingsFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
