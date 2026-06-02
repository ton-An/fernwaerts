import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/invalid_invite_link_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/accept_invite.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/recover_invite_session.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_state.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures.dart';

class MockInitializeNewSupabaseConnection extends Mock
    implements InitializeNewSupabaseConnection {}

class MockRecoverInviteSession extends Mock implements RecoverInviteSession {}

class MockAcceptInvite extends Mock implements AcceptInvite {}

class MockRequestNecessaryPermissions extends Mock
    implements RequestNecessaryPermissions {}

class MockInitBackgroundLocationTracking extends Mock
    implements InitBackgroundLocationTracking {}

void main() {
  late InviteCubit cubit;
  late MockInitializeNewSupabaseConnection mockInitializeNewSupabaseConnection;
  late MockRecoverInviteSession mockRecoverInviteSession;
  late MockAcceptInvite mockAcceptInvite;
  late MockRequestNecessaryPermissions mockRequestNecessaryPermissions;
  late MockInitBackgroundLocationTracking mockInitBackgroundLocationTracking;

  setUpAll(() {
    registerFallbackValue(tSupabaseInfo);
  });

  setUp(() {
    mockInitializeNewSupabaseConnection = MockInitializeNewSupabaseConnection();
    mockRecoverInviteSession = MockRecoverInviteSession();
    mockAcceptInvite = MockAcceptInvite();
    mockRequestNecessaryPermissions = MockRequestNecessaryPermissions();
    mockInitBackgroundLocationTracking = MockInitBackgroundLocationTracking();

    cubit = InviteCubit(
      initializeNewSupabaseConnection: mockInitializeNewSupabaseConnection,
      recoverInviteSession: mockRecoverInviteSession,
      acceptInviteUsecase: mockAcceptInvite,
      requestNecessaryPermissions: mockRequestNecessaryPermissions,
      initBackgroundLocationTracking: mockInitBackgroundLocationTracking,
    );

    when(
      () => mockInitializeNewSupabaseConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(tSupabaseInfo));
    when(
      () => mockRecoverInviteSession(refreshToken: any(named: 'refreshToken')),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockAcceptInvite(
        supabaseInfo: any(named: 'supabaseInfo'),
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockRequestNecessaryPermissions(),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockInitBackgroundLocationTracking(),
    ).thenAnswer((_) async => const Right(None()));
  });

  tearDown(() async {
    await cubit.close();
  });

  group('initializeInvite', () {
    test('returns to the form state after initialization succeeds', () async {
      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([isA<InviteLoading>(), isA<InviteInitial>()]),
      );

      // act
      cubit.initializeInvite(serverUrl: tServerUrlString, refreshToken: tOtp);

      // assert
      await expectedStates;
    });

    test('emits a failure when invite session recovery fails', () async {
      // arrange
      when(
        () =>
            mockRecoverInviteSession(refreshToken: any(named: 'refreshToken')),
      ).thenAnswer((_) async => const Left(StorageWriteFailure()));

      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<InviteLoading>(),
          isA<InviteFailure>().having(
            (state) => state.failure,
            'failure',
            const StorageWriteFailure(),
          ),
        ]),
      );

      // act
      cubit.initializeInvite(serverUrl: tServerUrlString, refreshToken: tOtp);

      // assert
      await expectedStates;
    });
  });

  group('acceptInvite', () {
    test('emits an invalid invite link failure when not initialized', () async {
      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emits(
          isA<InviteFailure>().having(
            (state) => state.failure,
            'failure',
            const InvalidInviteLinkFailure(),
          ),
        ),
      );

      // act
      cubit.acceptInvite(username: tUsername, password: tPassword);

      // assert
      await expectedStates;
      verifyNever(
        () => mockAcceptInvite(
          supabaseInfo: any(named: 'supabaseInfo'),
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test(
      'starts local tracking setup after accepting initialized invite',
      () async {
        // arrange
        final initStates = expectLater(
          cubit.stream,
          emitsInOrder([isA<InviteLoading>(), isA<InviteInitial>()]),
        );

        // act
        cubit.initializeInvite(serverUrl: tServerUrlString, refreshToken: tOtp);

        // assert
        await initStates;

        // arrange
        final expectedStates = expectLater(
          cubit.stream,
          emitsInOrder([isA<InviteLoading>(), isA<InviteSuccess>()]),
        );

        // act
        cubit.acceptInvite(username: tUsername, password: tPassword);

        // assert
        await expectedStates;
        verify(() => mockRequestNecessaryPermissions()).called(1);
        verify(() => mockInitBackgroundLocationTracking()).called(1);
      },
    );

    test(
      'emits a failure when permission setup fails after accepting',
      () async {
        // arrange
        final initStates = expectLater(
          cubit.stream,
          emitsInOrder([isA<InviteLoading>(), isA<InviteInitial>()]),
        );

        // act
        cubit.initializeInvite(serverUrl: tServerUrlString, refreshToken: tOtp);

        // assert
        await initStates;

        // arrange
        when(
          () => mockRequestNecessaryPermissions(),
        ).thenAnswer((_) async => const Left(StorageWriteFailure()));

        // arrange
        final expectedStates = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<InviteLoading>(),
            isA<InviteFailure>().having(
              (state) => state.failure,
              'failure',
              const StorageWriteFailure(),
            ),
          ]),
        );

        // act
        cubit.acceptInvite(username: tUsername, password: tPassword);

        // assert
        await expectedStates;
      },
    );
  });
}
