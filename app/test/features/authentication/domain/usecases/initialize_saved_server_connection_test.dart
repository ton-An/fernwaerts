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
  late MockInitializeServerConnection mockInitializeServerConnection;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockInitializeServerConnection = MockInitializeServerConnection();
    initializeSavedServerConnection = InitializeSavedServerConnection(
      authenticationRepository: mockAuthenticationRepository,
      initializeServerConnection: mockInitializeServerConnection,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerUrl(),
    ).thenAnswer((_) async => Right(tServerUrlString));
    when(
      () => mockInitializeServerConnection(serverUrl: any(named: 'serverUrl')),
    ).thenAnswer((_) async => Right(None()));
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
    ).thenAnswer((_) async => Left(StorageReadFailure()));

    // act
    final result = await initializeSavedServerConnection();

    // assert
    expect(result, Left(StorageReadFailure()));
  });

  test('should initialize the server and return None', () async {
    // act
    final result = await initializeSavedServerConnection();

    // assert
    verify(() => mockInitializeServerConnection(serverUrl: tServerUrlString));
    expect(result, Right(None()));
  });

  test('should relay Failures from initializing the server', () async {
    // arrange
    when(
      () => mockInitializeServerConnection(serverUrl: any(named: 'serverUrl')),
    ).thenAnswer((_) async => Left(SendTimeoutFailure()));

    // act
    final result = await initializeSavedServerConnection();

    // assert
    expect(result, Left(SendTimeoutFailure()));
  });
}
