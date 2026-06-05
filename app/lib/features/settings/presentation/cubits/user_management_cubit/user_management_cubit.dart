import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/settings/domain/usecases/watch_users.dart';
import 'package:location_history/features/settings/presentation/cubits/user_management_cubit/user_management_state.dart';

/// {@template user_management_cubit}
/// Coordinates the synced user-management list for settings.
/// {@endtemplate}
class UserManagementCubit extends Cubit<UserManagementState> {
  /// {@macro user_management_cubit}
  UserManagementCubit({required this.watchUsersUseCase})
    : super(const UserManagementInitial());

  /// Use case that streams public user profiles visible to the current user.
  final WatchUsers watchUsersUseCase;

  StreamSubscription<Either<Failure, List<User>>>? _usersSubscription;

  /// Starts watching the synced user list.
  ///
  /// Emits:
  /// - [UserManagementLoading] while the stream is being attached.
  /// - [UserManagementLoaded] whenever synced users change.
  /// - [UserManagementFailure] when the stream reports a recoverable failure.
  void watchUsers() {
    emit(const UserManagementLoading());
    _usersSubscription?.cancel();

    _usersSubscription = watchUsersUseCase().listen((usersEither) {
      usersEither.fold(
        (Failure failure) => emit(UserManagementFailure(failure: failure)),
        (List<User> users) => emit(UserManagementLoaded(users: users)),
      );
    });
  }

  @override
  Future<void> close() async {
    await _usersSubscription?.cancel();

    return super.close();
  }
}
