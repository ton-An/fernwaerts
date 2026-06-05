import 'package:equatable/equatable.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';

/// {@template user_management_state}
/// Base state for the user-management settings list.
/// {@endtemplate}
abstract class UserManagementState extends Equatable {
  /// {@macro user_management_state}
  const UserManagementState();

  @override
  List<Object> get props => [];
}

/// {@template user_management_initial}
/// User management has not started loading synced users.
/// {@endtemplate}
class UserManagementInitial extends UserManagementState {
  /// {@macro user_management_initial}
  const UserManagementInitial();
}

/// {@template user_management_loading}
/// The visible synced user list is being loaded.
/// {@endtemplate}
class UserManagementLoading extends UserManagementState {
  /// {@macro user_management_loading}
  const UserManagementLoading();
}

/// {@template user_management_loaded}
/// Visible synced users are available for display.
/// {@endtemplate}
class UserManagementLoaded extends UserManagementState {
  /// {@macro user_management_loaded}
  const UserManagementLoaded({required this.users});

  /// Public user profiles visible to the current user.
  final List<User> users;

  @override
  List<Object> get props => [users];
}

/// {@template user_management_failure}
/// Loading synced users failed.
/// {@endtemplate}
class UserManagementFailure extends UserManagementState {
  /// {@macro user_management_failure}
  const UserManagementFailure({required this.failure});

  /// Failure returned while watching the synced user list.
  final Failure failure;

  @override
  List<Object> get props => [failure];
}
