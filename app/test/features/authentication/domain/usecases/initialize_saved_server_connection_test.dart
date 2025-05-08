import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late InitializeSavedServerConnection initializeSavedServerConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    initializeSavedServerConnection = InitializeSavedServerConnection(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerInfo(),
    ).thenAnswer((_) async => const Right(tServerInfo));
    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverInfo: any(named: 'serverInfo'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tServerInfo);
  });

  test('should get the saved server info', () async {
    // act
    await initializeSavedServerConnection();

    // assert
    verify(() => mockAuthenticationRepository.getSavedServerInfo());
  });

  test('should relay Failures from getting saved server info', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getSavedServerInfo(),
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
        serverInfo: tServerInfo,
      ),
    );
    expect(result, const Right(None()));
  });

  test('should relay Failures from initializing the server', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.initializeServerConnection(
        serverInfo: any(named: 'serverInfo'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await initializeSavedServerConnection();

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });
}
