import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late InitializeSavedServerConnection initializeSavedServerConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    initializeSavedServerConnection = InitializeSavedServerConnection(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerUrl(),
    ).thenAnswer((_) async => const Right(tServerUrlString));
    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  test('should get the saved server url', () async {
    // act
    await initializeSavedServerConnection();

    // assert
    verify(() => mockAuthenticationRepository.getSavedServerUrl());
  });

  test('should relay Failures from getting saved server url', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getSavedServerUrl(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await initializeSavedServerConnection();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should initialize the server and return None', () async {
    // act
    final result = await initializeSavedServerConnection();

    // assert
    verify(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: tServerUrlString,
      ),
    );
    expect(result, const Right(None()));
  });

  test('should relay Failures from initializing the server', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await initializeSavedServerConnection();

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });
}
