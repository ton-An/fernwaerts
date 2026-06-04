import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

// TODO: Handle sign-out exceptions when the device is offline.

/// {@template sign_out}
/// Signs out the current user and clears local session state.
///
/// The flow stops location tracking, resets PowerSync, signs out of auth,
/// deletes the local database cache, and removes saved local
/// authentication/server storage.
///
/// Failures:
/// - [StorageWriteFailure]
///
/// The auth sign-out, tracking stop, and local cache cleanup calls currently
/// propagate their own exceptions if they fail before storage removal.
/// {@endtemplate}
class SignOut {
  /// {@macro sign_out}
  const SignOut({
    required this.authenticationRepository,
    required this.locationTrackingRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationTrackingRepository locationTrackingRepository;

  /// {@macro sign_out}
  Future<Either<Failure, None>> call() {
    return _stopTracking();
  }

  Future<Either<Failure, None>> _stopTracking() async {
    await locationTrackingRepository.stopTracking();

    return _resetPowerSync();
  }

  Future<Either<Failure, None>> _resetPowerSync() async {
    await authenticationRepository.resetPowerSync();

    return signOut();
  }

  Future<Either<Failure, None>> signOut() async {
    await authenticationRepository.signOut();

    return _deleteLocalDBCache();
  }

  Future<Either<Failure, None>> _deleteLocalDBCache() async {
    await authenticationRepository.deleteLocalDBCache();

    return _deleteLocalStorage();
  }

  Future<Either<Failure, None>> _deleteLocalStorage() async {
    return authenticationRepository.deleteLocalStorage();
  }
}
