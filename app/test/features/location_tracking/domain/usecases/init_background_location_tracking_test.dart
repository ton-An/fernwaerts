import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late InitBackgroundLocationTracking locationTrackingHandler;
  late MockInitializeSavedServerConnection mockInitializeSavedServerConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockDeviceRepository mockDeviceRepository;
  late MockLocationTrackingRepository mockLocationTrackingRepository;
  late MockLocationDataRepository mockLocationDataRepository;

  setUp(() {
    mockInitializeSavedServerConnection = MockInitializeSavedServerConnection();
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockDeviceRepository = MockDeviceRepository();
    mockLocationTrackingRepository = MockLocationTrackingRepository();
    mockLocationDataRepository = MockLocationDataRepository();
    locationTrackingHandler = InitBackgroundLocationTracking(
      authenticationRepository: mockAuthenticationRepository,
      deviceRepository: mockDeviceRepository,
      locationTrackingRepository: mockLocationTrackingRepository,
      locationDataRepository: mockLocationDataRepository,
      initializeSavedServerConnection: mockInitializeSavedServerConnection,
    );
  });

  setUp(() {
    when(
      () => mockInitializeSavedServerConnection(),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Right(tUserId));
    when(
      () => mockDeviceRepository.getDeviceIdFromStorage(),
    ).thenAnswer((_) async => const Right(tDeviceId));
    when(
      () => mockLocationTrackingRepository.initTracking(),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockLocationTrackingRepository.locationChangeStream(),
    ).thenAnswer(
      (_) => Stream<RecordedLocation>.fromIterable(tRecordedLocations),
    );
    when(
      () => mockLocationDataRepository.saveLocation(
        location: any(named: 'location'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tLocations[0]);
  });

  test('should init the saved server connection', () async {
    // act
    await locationTrackingHandler();

    // assert
    verify(() => mockInitializeSavedServerConnection());
  });

  test('should relay failures from init the saved server connection', () async {
    // arrange
    when(
      () => mockInitializeSavedServerConnection(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await locationTrackingHandler();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should get the current user', () async {
    // act
    await locationTrackingHandler();

    // assert
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the current user', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await locationTrackingHandler();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should get the device info', () async {
    // act
    await locationTrackingHandler();

    // assert
    verify(() => mockDeviceRepository.getDeviceIdFromStorage());
  });

  test('should relay failures from getting the device info', () async {
    // arrange
    when(
      () => mockDeviceRepository.getDeviceIdFromStorage(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await locationTrackingHandler();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should initialize tracking', () async {
    // act
    await locationTrackingHandler();

    // assert
    verify(() => mockLocationTrackingRepository.initTracking());
  });

  test(
    'should listen for location changes and save them to the database',
    () async {
      // act
      await locationTrackingHandler();
      await Future.delayed(const Duration(seconds: 1));

      // assert
      verify(() => mockLocationTrackingRepository.locationChangeStream());
      verify(
        () => mockLocationDataRepository.saveLocation(location: tLocations[0]),
      );
      verify(
        () => mockLocationDataRepository.saveLocation(location: tLocations[1]),
      );
    },
  );
}
