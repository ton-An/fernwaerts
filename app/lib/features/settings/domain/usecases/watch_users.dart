import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

/// {@template watch_users}
/// Watches public user profiles visible to the current user.
///
/// Returns:
/// - [Stream] of [Either] values containing [Failure]s or visible [User]s
///
/// Failures:
/// - [DatabaseReadFailure]
/// {@endtemplate}
class WatchUsers {
  /// {@macro watch_users}
  const WatchUsers({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  /// {@macro watch_users}
  Stream<Either<Failure, List<User>>> call() {
    return settingsRepository.watchUsers();
  }
}
