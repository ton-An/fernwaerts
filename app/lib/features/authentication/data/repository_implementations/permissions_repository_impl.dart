import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';

/// {@template permissions_repository_impl}
/// A class that represents permissions repository impl.
/// {@endtemplate}
class PermissionsRepositoryImpl extends PermissionsRepository {
/// {@macro permissions_repository_impl}
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
