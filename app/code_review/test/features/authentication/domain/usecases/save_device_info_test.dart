import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/save_device_info_to_db.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late SaveDeviceInfo saveDeviceInfo;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockDeviceRepository = MockDeviceRepository();

    saveDeviceInfo = SaveDeviceInfo(
      authenticationRepository: mockAuthenticationRepository,
      deviceRepository: mockDeviceRepository,
    );

    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Right(tUserId));
    when(() => mockDeviceRepository.getAppVersion()).thenReturn(tAppVersion);
    when(
      () => mockDeviceRepository.getRawDeviceInfo(),
    ).thenAnswer((_) async => const Right(tIOSRawDevice));
    when(
      () =>
          mockDeviceRepository.saveDeviceInfoToDB(device: any(named: 'device')),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockDeviceRepository.saveDeviceIdToStorage(
        deviceId: any(named: 'deviceId'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tDevice);
  });

  test('should get the current users id', () async {
    // act
    await saveDeviceInfo();

    // assert
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the current user id', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(NotSignedInFailure()));

    // act
    final result = await saveDeviceInfo();

    // assert
    expect(result, const Left(NotSignedInFailure()));
  });

  test('should get the app version', () async {
    // act
    await saveDeviceInfo();

    // assert
    verify(() => mockDeviceRepository.getAppVersion());
  });

  test('should get the raw device info', () async {
    // act
    await saveDeviceInfo();

    // assert
    verify(() => mockDeviceRepository.getRawDeviceInfo());
  });

  test('should relay failures from getting the raw device info', () async {
    // arrange
    when(() => mockDeviceRepository.getRawDeviceInfo()).thenAnswer(
      (_) async => const Left(DeviceInfoPlatformNotSupportedFailure()),
    );

    // act
    final result = await saveDeviceInfo();

    // assert
    expect(result, const Left(DeviceInfoPlatformNotSupportedFailure()));
  });

  test('should save the device info to the database', () async {
    // act
    await saveDeviceInfo();

    // assert
    verify(
      () =>
          mockDeviceRepository.saveDeviceInfoToDB(device: any(named: 'device')),
    );
  });

  test('should save the device id to storage and return None', () async {
    // act
    final result = await saveDeviceInfo();

    // assert
    verify(
      () => mockDeviceRepository.saveDeviceIdToStorage(
        deviceId: any(named: 'deviceId'),
      ),
    );
    expect(result, const Right(None()));
  });

  test('should relay failures from saving the device id to storage', () async {
    // arrange
    when(
      () => mockDeviceRepository.saveDeviceIdToStorage(
        deviceId: any(named: 'deviceId'),
      ),
    ).thenAnswer((_) async => const Left(StorageWriteFailure()));

    // act
    final result = await saveDeviceInfo();

    // assert
    expect(result, const Left(StorageWriteFailure()));
  });
}
