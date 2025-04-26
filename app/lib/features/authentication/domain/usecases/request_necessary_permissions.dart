import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';

class RequestNecessaryPermissions {
  const RequestNecessaryPermissions({required this.permissionsRepository});

  final PermissionsRepository permissionsRepository;

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
