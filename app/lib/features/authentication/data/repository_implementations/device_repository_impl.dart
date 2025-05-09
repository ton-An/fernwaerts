import 'package:flutter/services.dart';
import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/option.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  DeviceRepositoryImpl({required this.baseDeviceLocalDataSource});

  final BaseDeviceLocalDataSource baseDeviceLocalDataSource;
  @override
  Future<Either<Failure, String>> getDeviceIdFromStorage() async {
    try {
      final String deviceId =
          await baseDeviceLocalDataSource.getDeviceIdFromStorage();

      return Right(deviceId);
    } on PlatformException {
      return const Left(StorageReadFailure());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Device>> getDeviceInfo() {
    // TODO: implement getDeviceInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveDeviceIdToStorage({
    required String deviceId,
  }) {
    // TODO: implement saveDeviceIdToStorage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveDeviceInfoToDB({required Device device}) {
    // TODO: implement saveDeviceInfoToDB
    throw UnimplementedError();
  }
}
