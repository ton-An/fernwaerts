import 'package:equatable/equatable.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class PasswordChangeState extends Equatable {
  const PasswordChangeState();

  @override
  List<Object?> get props => [];
}

class PasswordChangeInitial extends PasswordChangeState {
  const PasswordChangeInitial();
}

class PasswordChangeLoading extends PasswordChangeState {
  const PasswordChangeLoading();
}

class PasswordChangeSuccess extends PasswordChangeState {
  const PasswordChangeSuccess();
}

class PasswordChangeFailure extends PasswordChangeState {
  const PasswordChangeFailure({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
