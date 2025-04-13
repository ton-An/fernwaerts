import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_server_connection.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late InitializeNewServerConnection initializeServerConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    initializeServerConnection = InitializeNewServerConnection(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(None()));

    when(
      () => mockAuthenticationRepository.isServerConnectionValid(),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
  });

  test('should initialize the connection to the server', () async {
    // act
    await initializeServerConnection(serverUrl: tServerUrlString);

    // assert
    verify(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: tServerUrlString,
      ),
    );
  });

  test('should relay Failures of connection initialization', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await initializeServerConnection(
      serverUrl: tServerUrlString,
    );

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });

  test('should check if server connection is valid and return None', () async {
    // act
    final result = await initializeServerConnection(
      serverUrl: tServerUrlString,
    );

    // assert
    verify(() => mockAuthenticationRepository.isServerConnectionValid());
    expect(result, const Right(None()));
  });

  test(
    'should relay Failures if server is not reachable, for whatever reason',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.isServerConnectionValid(),
      ).thenAnswer((_) async => const Left(InvalidUrlFormatFailure()));

      // act
      final result = await initializeServerConnection(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(result, const Left(InvalidUrlFormatFailure()));
    },
  );
}
