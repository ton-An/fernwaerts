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
      () => mockAuthenticationRepository.initializeSupabaseConnection(
        supabaseInfo: any(named: 'supabaseInfo'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockAuthenticationRepository.initializeSyncServerConnection(
        powersyncInfo: any(named: 'powersyncInfo'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tSupabaseInfo);
    registerFallbackValue(tPowersyncInfo);
  });

  test(
    'should return early with None if the server is already set up',
    () async {
      // arrange
      await initializeSavedServerConnection();

      // act
      final result = await initializeSavedServerConnection();

      // assert
      expect(result, const Right(None()));
      verify(() => mockAuthenticationRepository.getSavedServerInfo()).called(1);
    },
  );

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

  test('should initialize the supabase server connection', () async {
    // act
    await initializeSavedServerConnection();

    // assert
    verify(
      () => mockAuthenticationRepository.initializeSupabaseConnection(
        supabaseInfo: tSupabaseInfo,
      ),
    );
  });

  test(
    'should relay Failures from initializing the supabase server connection',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.initializeSupabaseConnection(
          supabaseInfo: any(named: 'supabaseInfo'),
        ),
      ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

      // act
      final result = await initializeSavedServerConnection();

      // assert
      expect(result, const Left(SendTimeoutFailure()));
    },
  );

  test(
    'should initialize the sync server connection and return None',
    () async {
      // act
      final result = await initializeSavedServerConnection();

      // assert
      verify(
        () => mockAuthenticationRepository.initializeSyncServerConnection(
          powersyncInfo: tPowersyncInfo,
        ),
      );
      expect(result, const Right(None()));
    },
  );

  test(
    'should relay Failures from initializing the sync server connection',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.initializeSyncServerConnection(
          powersyncInfo: any(named: 'powersyncInfo'),
        ),
      ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

      // act
      final result = await initializeSavedServerConnection();

      // assert
      expect(result, const Left(SendTimeoutFailure()));
    },
  );
}
