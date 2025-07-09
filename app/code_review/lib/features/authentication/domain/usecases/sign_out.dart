import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
    - [ ] Hanlde exception on sign out without internet
*/

/// {@template sign_out}
/// Signs out the current user
///
/// Failures:
/// - [StorageWriteFailure]
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
    return _signOut();
  }

  Future<Either<Failure, None>> _signOut() async {
    await authenticationRepository.signOut();

    return _stopTracking();
  }

  Future<Either<Failure, None>> _stopTracking() async {
    await locationTrackingRepository.stopTracking();

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
