import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/usecases/accept_invite.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_states.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/* 
  To-Do:
    - [ ] Add tests
*/

class InviteCubit extends Cubit<InviteCubitState> {
  InviteCubit({
    required this.initializeNewSupabaseConnection,
    required this.acceptInviteUsecase,
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
  }) : super(const InviteInitialState());

  final InitializeNewSupabaseConnection initializeNewSupabaseConnection;
  final AcceptInvite acceptInviteUsecase;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;

  // log in with tokens temp (needs to log out on next restart)

  void acceptInvite({
    required String username,
    required String password,
    required String serverUrl,
  }) async {
    emit(const InviteLoading());
    _initializeNewSupabaseConnection(
      username: username,
      password: password,
      serverUrl: serverUrl,
    );
  }

  void _initializeNewSupabaseConnection({
    required String username,
    required String password,
    required String serverUrl,
  }) async {
    final Either<Failure, SupabaseInfo> initializeNewSupabaseConnectionEither =
        await initializeNewSupabaseConnection(serverUrl: serverUrl);

    initializeNewSupabaseConnectionEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (SupabaseInfo supabaseInfo) async {
        _acceptInvite(
          username: username,
          password: password,
          supabaseInfo: supabaseInfo,
        );
      },
    );
  }

  void _acceptInvite({
    required String username,
    required String password,
    required SupabaseInfo supabaseInfo,
  }) async {
    final Either<Failure, None> acceptInviteEither = await acceptInviteUsecase(
      supabaseInfo: supabaseInfo,
      username: username,
      password: password,
    );

    acceptInviteEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (None none) {
        _requestNecessaryPermissions();
      },
    );
  }

  void _requestNecessaryPermissions() async {
    // final Either<Failure, None> requestPermissionsEither =
    await requestNecessaryPermissions();

    // requestPermissionsEither.fold(
    //   (Failure failure) {
    //     emit(AuthenticationFailure(failure: failure));
    //   },
    //   (None none) {
    _initBackgroundLocationTracking();
    //   },
    // );
  }

  void _initBackgroundLocationTracking() async {
    final initTrackingEither = await initBackgroundLocationTracking();

    initTrackingEither.fold((Failure failure) {
      emit(InviteFailure(failure: failure));
    }, (_) {});
  }
}
