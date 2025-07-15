import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/data/datasources/platform_wrapper.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/datasources/android_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/device_remote_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/ios_device_local_data_source.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';

/// {@template device_repository_impl}
/// A class that represents device repository impl.
/// {@endtemplate}
class DeviceRepositoryImpl extends DeviceRepository {
/// {@macro device_repository_impl}
  DeviceRepositoryImpl({
    required this.baseDeviceLocalDataSource,
    required this.iosDeviceLocalDataSource,
    required this.androidDeviceLocalDataSource,
    required this.deviceRemoteDataSource,
    required this.platformWrapper,
  });

  final BaseDeviceLocalDataSource baseDeviceLocalDataSource;
  final IOSDeviceLocalDataSource iosDeviceLocalDataSource;
  final AndroidDeviceLocalDataSource androidDeviceLocalDataSource;
  final DeviceRemoteDataSource deviceRemoteDataSource;
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

    if (platformWrapper.isAndroid) {
      final RawDevice androidRawDevice =
          await androidDeviceLocalDataSource.getRawDeviceInfo();

      return Right(androidRawDevice);
    }

    return const Left(DeviceInfoPlatformNotSupportedFailure());
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
  Future<void> saveDeviceInfoToDB({required Device device}) {
    return deviceRemoteDataSource.saveDeviceInfoToDB(device: device);
  }

  @override
  String getAppVersion() {
    return baseDeviceLocalDataSource.getAppVersion();
  }
}
