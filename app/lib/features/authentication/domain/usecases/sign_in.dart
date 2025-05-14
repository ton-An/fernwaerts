import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/save_device_info_to_db.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template sign_in}
/// Signs in a user with a given email and password
///
/// Parameters:
/// - [String] email
/// - [String] password
///
/// Failures:
/// {@macro converted_client_exceptions}
/// - [InvalidCredentialsFailure]
/// - [NotSignedInFailure]
/// - [DeviceInfoPlatformNotSupportedFailure]
/// - [StorageWriteFailure]
/// {@endtemplate}
class SignIn {
  /// {@macro sign_in}
  const SignIn({
    required this.authenticationRepository,
    required this.saveDeviceInfo,
  });

  final AuthenticationRepository authenticationRepository;
  final SaveDeviceInfo saveDeviceInfo;

  /// {@macro sign_in}
  Future<Either<Failure, None>> call({
    required String email,
    required String password,
    required ServerInfo serverInfo,
  }) {
    return _signIn(email: email, password: password, serverInfo: serverInfo);
  }

  Future<Either<Failure, None>> _signIn({
    required String email,
    required String password,
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> signInEither = await authenticationRepository
        .signIn(email: email, password: password);

    return signInEither.fold(Left.new, (None none) {
      return _saveServerInfo(serverInfo: serverInfo);
    });
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
