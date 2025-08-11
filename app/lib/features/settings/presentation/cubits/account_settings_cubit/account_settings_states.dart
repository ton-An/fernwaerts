import 'package:equatable/equatable.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';

abstract class AccountSettingsState extends Equatable {
  const AccountSettingsState();
}

class AccountSettingsLoading extends AccountSettingsState {
  const AccountSettingsLoading();

  @override
  List<Object> get props => [];
}

abstract class AccountSettingsLoaded extends AccountSettingsState {
  const AccountSettingsLoaded({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class AccountSettingsInitialLoaded extends AccountSettingsLoaded {
  const AccountSettingsInitialLoaded({required super.user});
}

class AccountSettingsUpdating extends AccountSettingsLoaded {
  const AccountSettingsUpdating({required super.user});
}

class AccountSettingsUpdated extends AccountSettingsLoaded {
  const AccountSettingsUpdated({required super.user});
}

class AccountSettingsFailure extends AccountSettingsState {
  const AccountSettingsFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
