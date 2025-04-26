import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';

class PermissionsRepositoryImpl extends PermissionsRepository {
  @override
  Future<Either<Failure, None>> requestActivityPermission() {
    // TODO: implement requestActivityPermission
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> requestLocationPermission() {
    // TODO: implement requestLocationPermission
    throw UnimplementedError();
  }
}
