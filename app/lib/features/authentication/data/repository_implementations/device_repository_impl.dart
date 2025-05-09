import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/option.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  @override
  Future<Either<Failure, String>> getDeviceIdFromStorage() {
    // TODO: implement getDeviceIdFromStorage
    throw UnimplementedError();
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
