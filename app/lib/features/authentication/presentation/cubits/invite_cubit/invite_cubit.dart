import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/invalid_invite_link_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/usecases/accept_invite.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/recover_invite_session.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_state.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/// {@template invite_cubit}
/// Coordinates accepting an invite link for a configured self-hosted server.
///
/// The cubit initializes the provided server URL, recovers the invite session,
/// accepts the invite with the chosen credentials, then requests platform
/// permissions and starts background location tracking.
/// {@endtemplate}
class InviteCubit extends Cubit<InviteState> {
  /// {@macro invite_cubit}
  InviteCubit({
    required this.initializeNewSupabaseConnection,
    required this.recoverInviteSession,
    required this.acceptInviteUsecase,
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
  }) : super(const InviteInitial());

  final InitializeNewSupabaseConnection initializeNewSupabaseConnection;
  final RecoverInviteSession recoverInviteSession;
  final AcceptInvite acceptInviteUsecase;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;
  SupabaseInfo? _supabaseInfo;

  /// Initializes the server connection and recovers the invite session.
  ///
  /// Emits:
  /// - [InviteLoading] while the server and invite session are initialized
  /// - [InviteFailure] when server initialization or session recovery fails
  /// - [InviteInitial] once the invite form can be submitted
  void initializeInvite({
    required String serverUrl,
    required String refreshToken,
  }) async {
    emit(const InviteLoading());
    _initializeNewSupabaseConnection(
      serverUrl: serverUrl,
      refreshToken: refreshToken,
    );
  }

  /// Accepts an invite with a new [username] and [password].
  ///
  /// Emits:
  /// - [InviteLoading] while the invite call and local startup are running
  /// - [InviteFailure] when invite acceptance or location tracking startup
  ///   fails
  /// - [InviteSuccess] once invite acceptance and local startup complete
  void acceptInvite({
    required String username,
    required String password,
  }) async {
    if (_supabaseInfo == null) {
      emit(const InviteFailure(failure: InvalidInviteLinkFailure()));
      return;
    }

    emit(const InviteLoading());
    _acceptInvite(
      username: username,
      password: password,
      supabaseInfo: _supabaseInfo!,
    );
  }

  void _initializeNewSupabaseConnection({
    required String serverUrl,
    required String refreshToken,
  }) async {
    final Either<Failure, SupabaseInfo> initializeNewSupabaseConnectionEither =
        await initializeNewSupabaseConnection(serverUrl: serverUrl);

    initializeNewSupabaseConnectionEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (SupabaseInfo supabaseInfo) async {
        _recoverInviteSession(
          supabaseInfo: supabaseInfo,
          refreshToken: refreshToken,
        );
      },
    );
  }

  void _recoverInviteSession({
    required SupabaseInfo supabaseInfo,
    required String refreshToken,
  }) async {
    final Either<Failure, None> recoverInviteSessionEither =
        await recoverInviteSession(refreshToken: refreshToken);

    recoverInviteSessionEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (None none) {
        _supabaseInfo = supabaseInfo;
        emit(const InviteInitial());
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
    final Either<Failure, None> requestPermissionsEither =
        await requestNecessaryPermissions();

    requestPermissionsEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (None none) {
        _initBackgroundLocationTracking();
      },
    );
  }

  void _initBackgroundLocationTracking() async {
    final initTrackingEither = await initBackgroundLocationTracking();

    initTrackingEither.fold(
      (Failure failure) {
        emit(InviteFailure(failure: failure));
      },
      (_) {
        emit(const InviteSuccess());
      },
    );
  }
}
