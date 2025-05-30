import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late SignIn signIn;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockSaveDeviceInfo mockSaveDeviceInfo;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockSaveDeviceInfo = MockSaveDeviceInfo();
    signIn = SignIn(
      authenticationRepository: mockAuthenticationRepository,
      saveDeviceInfo: mockSaveDeviceInfo,
    );

    when(
      () => mockAuthenticationRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockAuthenticationRepository.saveServerInfo(
        serverInfo: any(named: 'serverInfo'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockSaveDeviceInfo(),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tServerInfo);
  });

  test('should sign in the user', () async {
    // act
    await signIn(serverInfo: tServerInfo, email: tEmail, password: tPassword);

    // assert
    verify(
      () => mockAuthenticationRepository.signIn(
        email: tEmail,
        password: tPassword,
      ),
    );
  });

  test('should relay Failures from signing in the user', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await signIn(
      serverInfo: tServerInfo,
      email: tEmail,
      password: tPassword,
    );

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });

  test('should save the server info', () async {
    // act
    await signIn(serverInfo: tServerInfo, email: tEmail, password: tPassword);

    // assert
    verify(
      () =>
          mockAuthenticationRepository.saveServerInfo(serverInfo: tServerInfo),
    );
  });

  test('should relay Failures saving the server info', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.saveServerInfo(
        serverInfo: any(named: 'serverInfo'),
      ),
    ).thenAnswer((_) async => const Left(StorageWriteFailure()));

    // act
    final result = await signIn(
      serverInfo: tServerInfo,
      email: tEmail,
      password: tPassword,
    );

    // assert
    expect(result, const Left(StorageWriteFailure()));
  });

  test('should save the device info and return None', () async {
    // act
    final result = await signIn(
      serverInfo: tServerInfo,
      email: tEmail,
      password: tPassword,
    );

    // assert
    expect(result, const Right(None()));
  });

  test('should relay Failures from saving the device info', () async {
    // arrange
    when(
      () => mockSaveDeviceInfo(),
    ).thenAnswer((_) async => const Left(NotSignedInFailure()));

    // act
    final result = await signIn(
      serverInfo: tServerInfo,
      email: tEmail,
      password: tPassword,
    );

    // assert
    expect(result, const Left(NotSignedInFailure()));
  });
}
