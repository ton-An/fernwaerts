import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/device_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late DeviceRepositoryImpl deviceRepositoryImpl;
  late MockBaseDeviceLocalDataSource mockBaseDeviceLocalDataSource;

  setUp(() {
    mockBaseDeviceLocalDataSource = MockBaseDeviceLocalDataSource();
    deviceRepositoryImpl = DeviceRepositoryImpl(
      baseDeviceLocalDataSource: mockBaseDeviceLocalDataSource,
    );
  });

  group('getCurrentDeviceId', () {
    setUp(() {
      when(
        () => mockBaseDeviceLocalDataSource.getDeviceIdFromStorage(),
      ).thenAnswer((_) async => tDeviceId);
    });

    test('should get the current device ID and return it', () async {
      // act
      final result = await deviceRepositoryImpl.getDeviceIdFromStorage();

      // assert
      verify(() => mockBaseDeviceLocalDataSource.getDeviceIdFromStorage());
      expect(result, const Right(tDeviceId));
    });

    test(
      'should convert PlatformException to StorageReadFailure and return it',
      () async {
        // arrange
        when(
          () => mockBaseDeviceLocalDataSource.getDeviceIdFromStorage(),
        ).thenThrow(tPlatformException);

        // act
        final result = await deviceRepositoryImpl.getDeviceIdFromStorage();

        // assert
        expect(result, const Left(StorageReadFailure()));
      },
    );

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockBaseDeviceLocalDataSource.getDeviceIdFromStorage(),
      ).thenThrow(const NoSavedDeviceFailure());

      // act
      final result = await deviceRepositoryImpl.getDeviceIdFromStorage();

      // assert
      expect(result, const Left<Failure, bool>(NoSavedDeviceFailure()));
    });
  });
}
