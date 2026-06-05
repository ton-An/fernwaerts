import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/account_already_set_up_failure.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/save_device_info_to_db.dart';

/// {@template accept_invite}
/// Accepts an invite for a known server.
///
/// The invite link must already have established a temporary Supabase session
/// for the invited user. This use case completes the invited account setup,
/// signs in with the newly set password, initializes sync, saves the selected
/// server, and registers the current device.
///
/// Parameters:
/// - supabaseInfo: [SupabaseInfo] connection info for the server
/// - username: [String] username to create from the invite
/// - password: [String] password to set for the invited user
///
/// Failures:
/// - [WeakPasswordFailure]
/// - [AccountAlreadySetUpFailure]
/// - [InvalidCredentialsFailure]
/// - [NotSignedInFailure]
/// - [DeviceInfoPlatformNotSupportedFailure]
/// - [StorageWriteFailure]
/// {@macro converted_client_exceptions}
/// {@macro converted_supabase_functions_exception}
/// {@endtemplate}
class AcceptInvite {
  /// {@macro accept_invite}
  const AcceptInvite({
    required this.authenticationRepository,
    required this.saveDeviceInfo,
  });

  final AuthenticationRepository authenticationRepository;
  final SaveDeviceInfo saveDeviceInfo;

  /// {@macro accept_invite}
  Future<Either<Failure, None>> call({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String password,
  }) async {
    return _getCurrentUserEmail(
      supabaseInfo: supabaseInfo,
      username: username,
      password: password,
    );
  }

  Future<Either<Failure, None>> _getCurrentUserEmail({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String password,
  }) async {
    final Either<Failure, String> currentUserEmailEither =
        await authenticationRepository.getCurrentUserEmail();

    return currentUserEmailEither.fold(
      Left.new,
      (String email) => _signUpInvitedUser(
        supabaseInfo: supabaseInfo,
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, None>> _signUpInvitedUser({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String email,
    required String password,
  }) async {
    final Either<Failure, None> signUpInvitedUserEither =
        await authenticationRepository.signUpInvitedUser(
          username: username,
          password: password,
        );

    return signUpInvitedUserEither.fold(
      Left.new,
      (None none) =>
          _signIn(supabaseInfo: supabaseInfo, email: email, password: password),
    );
  }

  Future<Either<Failure, None>> _signIn({
    required SupabaseInfo supabaseInfo,
    required String email,
    required String password,
  }) async {
    final Either<Failure, None> signInEither = await authenticationRepository
        .signIn(email: email, password: password);

    return signInEither.fold(
      Left.new,
      (None none) => _getSyncServerInfo(supabaseInfo: supabaseInfo),
    );
  }

  Future<Either<Failure, None>> _getSyncServerInfo({
    required SupabaseInfo supabaseInfo,
  }) async {
    final Either<Failure, PowersyncInfo> getSyncServerInfoEither =
        await authenticationRepository.getSyncServerInfo();

    return getSyncServerInfoEither.fold(Left.new, (
      PowersyncInfo powersyncInfo,
    ) {
      final ServerInfo serverInfo = ServerInfo(
        supabaseInfo: supabaseInfo,
        powersyncInfo: powersyncInfo,
      );

      return _isSyncServerConnectionValid(serverInfo: serverInfo);
    });
  }

  Future<Either<Failure, None>> _isSyncServerConnectionValid({
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> isSyncServerConnectionValidEither =
        await authenticationRepository.isSyncServerConnectionValid(
          syncServerUrl: serverInfo.powersyncInfo.url,
        );

    return isSyncServerConnectionValidEither.fold(
      Left.new,
      (None none) => _initializeSyncServer(serverInfo: serverInfo),
    );
  }

  Future<Either<Failure, None>> _initializeSyncServer({
    required ServerInfo serverInfo,
  }) async {
    await authenticationRepository.initializeSyncServerConnection(
      powersyncInfo: serverInfo.powersyncInfo,
    );

    return _saveServerInfo(serverInfo: serverInfo);
  }

  Future<Either<Failure, None>> _saveServerInfo({
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> saveServerInfoEither =
        await authenticationRepository.saveServerInfo(serverInfo: serverInfo);

    return saveServerInfoEither.fold(
      Left.new,
      (None none) => _saveDeviceInfo(),
    );
  }

  Future<Either<Failure, None>> _saveDeviceInfo() async {
    return saveDeviceInfo();
  }
}
