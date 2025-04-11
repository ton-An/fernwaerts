import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late SignIn signIn;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signIn = SignIn(authenticationRepository: mockAuthenticationRepository);

    when(
      () => mockAuthenticationRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockAuthenticationRepository.saveServerUrl(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  test('should sign in the user', () async {
    // act
    await signIn(
      email: tEmail,
      password: tPassword,
      serverUrl: tServerUrlString,
    );

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
      email: tEmail,
      password: tPassword,
      serverUrl: tServerUrlString,
    );

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });

  test('should save the server url and return None', () async {
    // act
    final result = await signIn(
      email: tEmail,
      password: tPassword,
      serverUrl: tServerUrlString,
    );

    // assert
    verify(
      () => mockAuthenticationRepository.saveServerUrl(
        serverUrl: tServerUrlString,
      ),
    );
    expect(result, const Right(None()));
  });

  test('should relay Failures saving the server url', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.saveServerUrl(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Left(StorageWriteFailure()));

    // act
    final result = await signIn(
      email: tEmail,
      password: tPassword,
      serverUrl: tServerUrlString,
    );

    // assert
    expect(result, const Left(StorageWriteFailure()));
  });
}
