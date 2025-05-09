import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/save_device_info_to_db.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late SaveDeviceInfoToDB saveDeviceInfoToDB;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockDeviceRepository mockDeviceRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockDeviceRepository = MockDeviceRepository();

    saveDeviceInfoToDB = SaveDeviceInfoToDB(
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
  });

  setUpAll(() {
    registerFallbackValue(tDevice);
  });

  test('should get the current users id', () async {
    // act
    await saveDeviceInfoToDB();

    // assert
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the current user id', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(NotSignedInFailure()));

    // act
    final result = await saveDeviceInfoToDB();

    // assert
    expect(result, const Left(NotSignedInFailure()));
  });

  test('should get the app version', () async {
    // act
    await saveDeviceInfoToDB();

    // assert
    verify(() => mockDeviceRepository.getAppVersion());
  });

  test('should get the raw device info', () async {
    // act
    await saveDeviceInfoToDB();

    // assert
    verify(() => mockDeviceRepository.getRawDeviceInfo());
  });

  test('should relay failures from getting the raw device info', () async {
    // arrange
    when(() => mockDeviceRepository.getRawDeviceInfo()).thenAnswer(
      (_) async => const Left(DeviceInfoPlatformNotSupportedFailure()),
    );

    // act
    final result = await saveDeviceInfoToDB();

    // assert
    expect(result, const Left(DeviceInfoPlatformNotSupportedFailure()));
  });

  test('should save the device info to the database and return none', () async {
    // act
    final result = await saveDeviceInfoToDB();

    // assert
    expect(result, const Right(None()));
  });
}
