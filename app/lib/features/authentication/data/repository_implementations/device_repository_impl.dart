import 'package:flutter/services.dart';
import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/option.dart';
import 'package:location_history/core/data/datasources/platform_wrapper.dart';
import 'package:location_history/core/failures/authentication/email_already_exists_failure%20copy.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/ios_device_local_data_source.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  DeviceRepositoryImpl({
    required this.baseDeviceLocalDataSource,
    required this.iosDeviceLocalDataSource,
    required this.platformWrapper,
  });

  final BaseDeviceLocalDataSource baseDeviceLocalDataSource;
  final IOSDeviceLocalDataSource iosDeviceLocalDataSource;
  final PlatformWrapper platformWrapper;

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
  Future<Either<Failure, RawDevice>> getRawDeviceInfo() async {
    if (platformWrapper.isIOS) {
      final RawDevice iosRawDevice =
          await iosDeviceLocalDataSource.getRawDeviceInfo();

      return Right(iosRawDevice);
    }

    return const Left(DeviceInfoPlatformNotSupported());
  }

  @override
  Future<Either<Failure, None>> saveDeviceIdToStorage({
    required String deviceId,
  }) async {
    try {
      await baseDeviceLocalDataSource.saveDeviceIdToStorage(deviceId: deviceId);

      return const Right(None());
    } on PlatformException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveDeviceInfoToDB({required Device device}) {
    // TODO: implement saveDeviceInfoToDB
    throw UnimplementedError();
  }
}
