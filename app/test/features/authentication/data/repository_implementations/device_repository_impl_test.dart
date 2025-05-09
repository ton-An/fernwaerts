import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/email_already_exists_failure%20copy.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/device_repository_impl.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late DeviceRepositoryImpl deviceRepositoryImpl;
  late MockBaseDeviceLocalDataSource mockBaseDeviceLocalDataSource;
  late MockIOSDeviceLocalDataSource mockIosDeviceLocalDataSource;
  late MockAndroidDeviceLocalDataSource mockAndroidDeviceLocalDataSource;
  late MockPlatformWrapper mockPlatformWrapper;

  setUp(() {
    mockBaseDeviceLocalDataSource = MockBaseDeviceLocalDataSource();
    mockIosDeviceLocalDataSource = MockIOSDeviceLocalDataSource();
    mockAndroidDeviceLocalDataSource = MockAndroidDeviceLocalDataSource();
    mockPlatformWrapper = MockPlatformWrapper();
    deviceRepositoryImpl = DeviceRepositoryImpl(
      baseDeviceLocalDataSource: mockBaseDeviceLocalDataSource,
      iosDeviceLocalDataSource: mockIosDeviceLocalDataSource,
      androidDeviceLocalDataSource: mockAndroidDeviceLocalDataSource,
      platformWrapper: mockPlatformWrapper,
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

  group('saveDeviceIdToStorage', () {
    setUp(() {
      when(
        () => mockBaseDeviceLocalDataSource.saveDeviceIdToStorage(
          deviceId: tDeviceId,
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should save the device id to storage and return None', () async {
      // act
      final result = await deviceRepositoryImpl.saveDeviceIdToStorage(
        deviceId: tDeviceId,
      );

      // assert
      verify(
        () => mockBaseDeviceLocalDataSource.saveDeviceIdToStorage(
          deviceId: tDeviceId,
        ),
      );
      expect(result, const Right<Failure, None>(None()));
    });

    test(
      'should convert PlatformException to StorageWriteFailure and return it',

      () async {
        // arrange
        when(
          () => mockBaseDeviceLocalDataSource.saveDeviceIdToStorage(
            deviceId: tDeviceId,
          ),
        ).thenThrow(tPlatformException);

        // act
        final result = await deviceRepositoryImpl.saveDeviceIdToStorage(
          deviceId: tDeviceId,
        );

        // assert
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });

  group('getRawDeviceInfo', () {
    setUp(() {
      when(() => mockPlatformWrapper.isIOS).thenReturn(false);
      when(() => mockPlatformWrapper.isAndroid).thenReturn(false);
    });

    test('should if the platform is ios get the ios device info', () async {
      // arrange
      when(() => mockPlatformWrapper.isIOS).thenReturn(true);
      when(
        () => mockIosDeviceLocalDataSource.getRawDeviceInfo(),
      ).thenAnswer((_) async => tIOSRawDevice);

      // act
      final result = await deviceRepositoryImpl.getRawDeviceInfo();

      // assert
      expect(result, const Right<Failure, RawDevice>(tIOSRawDevice));
    });

    test(
      'should if the platform is android get the android device info',
      () async {
        // arrange
        when(() => mockPlatformWrapper.isAndroid).thenReturn(true);
        when(
          () => mockAndroidDeviceLocalDataSource.getRawDeviceInfo(),
        ).thenAnswer((_) async => tAndroidRawDevice);

        // act
        final result = await deviceRepositoryImpl.getRawDeviceInfo();

        // assert
        expect(result, const Right<Failure, RawDevice>(tAndroidRawDevice));
      },
    );

    test(
      'should return DeviceInfoPlatformNotSupported if the platform is not handled',
      () async {
        // act
        final result = await deviceRepositoryImpl.getRawDeviceInfo();

        // assert
        expect(result, const Left(DeviceInfoPlatformNotSupported()));
      },
    );
  });
}
