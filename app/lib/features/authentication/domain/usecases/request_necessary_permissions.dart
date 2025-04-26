import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';

/// {@template request_necessary_permissions}
/// Requests necessary permissions for the application.
///
/// Failures:
/// - [BasicLocationPermissionNotGrantedFailure]
/// - [BackgroundLocationPermissionNotGrantedFailure]
/// - [ActivityPermissionNotGrantedFailure]
/// {@endtemplate}
class RequestNecessaryPermissions {
  /// {@macro request_necessary_permissions}
  const RequestNecessaryPermissions({required this.permissionsRepository});

  final PermissionsRepository permissionsRepository;

  /// {@macro request_necessary_permissions}
  Future<Either<Failure, None>> call() async {
    return _requestLocationPermission();
  }

  Future<Either<Failure, None>> _requestLocationPermission() async {
    final Either<Failure, None> locationPermissionEither =
        await permissionsRepository.requestLocationPermission();

    return locationPermissionEither.fold(Left.new, (None none) {
      return _requestActivityPermission();
    });
  }

  Future<Either<Failure, None>> _requestActivityPermission() async {
    final Either<Failure, None> activityPermissionEither =
        await permissionsRepository.requestActivityPermission();

    return activityPermissionEither.fold(Left.new, (None none) {
      return const Right(None());
    });
  }
}
