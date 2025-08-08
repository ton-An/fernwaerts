import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late InitializeApp initializeSavedServerConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    initializeSavedServerConnection = InitializeApp(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerInfo(),
    ).thenAnswer((_) async => const Right(tServerInfo));
    when(
      () => mockAuthenticationRepository.initializeSupabaseConnection(
        supabaseInfo: any(named: 'supabaseInfo'),
      ),
    ).thenAnswer((_) async => Future.value());
    when(
      () => mockAuthenticationRepository.isSignedIn(),
    ).thenAnswer((_) async => Future.value(true));
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

  test('should check if the user is signed in', () async {
    // act
    await initializeSavedServerConnection();

    // assert
    verify(() => mockAuthenticationRepository.isSignedIn());
  });

  test(
    'should return a not signed in failure if the user is not signed in',
    () async {
      // act
      final result = await initializeSavedServerConnection();

      // assert
      expect(result, const Left(NotSignedInFailure()));
      verify(() => mockAuthenticationRepository.isSignedIn());
    },
  );

  test(
    'should return before initializing the sync server with None if the server is already set up',
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
}
