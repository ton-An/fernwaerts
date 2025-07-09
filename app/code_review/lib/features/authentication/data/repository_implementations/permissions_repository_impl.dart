import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';

class PermissionsRepositoryImpl extends PermissionsRepository {
  const PermissionsRepositoryImpl({required this.permissionsLocalDataSource});

  final PermissionsLocalDataSource permissionsLocalDataSource;

  @override
  Future<Either<Failure, None>> requestActivityPermission() async {
    try {
      await permissionsLocalDataSource.requestActivityPermission();

      return const Right(None());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> requestLocationPermission() async {
    try {
      await permissionsLocalDataSource.requestLocationPermission();

      return const Right(None());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
