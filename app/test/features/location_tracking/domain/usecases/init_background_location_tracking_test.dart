import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late InitBackgroundLocationTracking initBackgroundLocationTracking;
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
    initBackgroundLocationTracking = InitBackgroundLocationTracking(
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
    ).thenAnswer((_) async => Future.value());
    when(
      () => mockLocationTrackingRepository.updateDistanceFilter(
        distanceFilter: any(named: 'distanceFilter'),
      ),
    ).thenAnswer((_) async => Future.value());
    when(
      () => mockLocationTrackingRepository.locationChangeStream(),
    ).thenAnswer(
      (_) => Stream<RecordedLocation>.fromIterable(tRecordedLocations),
    );
    when(
      () => mockLocationDataRepository.saveLocation(
        location: any(named: 'location'),
      ),
    ).thenAnswer((_) async => Future.value());
  });

  setUpAll(() {
    registerFallbackValue(tLocations[0]);
  });

  test('should init the saved server connection', () async {
    // act
    await initBackgroundLocationTracking();

    // assert
    verify(() => mockInitializeSavedServerConnection());
  });

  test('should relay failures from init the saved server connection', () async {
    // arrange
    when(
      () => mockInitializeSavedServerConnection(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await initBackgroundLocationTracking();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should get the current user', () async {
    // act
    await initBackgroundLocationTracking();

    // assert
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the current user', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await initBackgroundLocationTracking();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should get the device info', () async {
    // act
    await initBackgroundLocationTracking();

    // assert
    verify(() => mockDeviceRepository.getDeviceIdFromStorage());
  });

  test('should relay failures from getting the device info', () async {
    // arrange
    when(
      () => mockDeviceRepository.getDeviceIdFromStorage(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await initBackgroundLocationTracking();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should initialize tracking', () async {
    // act
    await initBackgroundLocationTracking();

    // assert
    verify(() => mockLocationTrackingRepository.initTracking());
  });

  test('should listen for location changes', () async {
    // act
    await initBackgroundLocationTracking();
    await Future.delayed(const Duration(seconds: 1));

    // assert
    verify(() => mockLocationTrackingRepository.locationChangeStream());
  });

  test('should update the distance filter', () async {
    // act
    await initBackgroundLocationTracking();
    await Future.delayed(const Duration(seconds: 1));

    // assert
    verify(
      () => mockLocationTrackingRepository.updateDistanceFilter(
        distanceFilter: any(
          named: 'distanceFilter',
          that: inInclusiveRange(100, 120),
        ),
      ),
    );
    verify(
      () => mockLocationTrackingRepository.updateDistanceFilter(
        distanceFilter: any(
          named: 'distanceFilter',
          that: inInclusiveRange(400, 550),
        ),
      ),
    );
    verify(
      () => mockLocationTrackingRepository.updateDistanceFilter(
        distanceFilter: any(
          named: 'distanceFilter',
          that: inInclusiveRange(3600, 4600),
        ),
      ),
    );
    verify(
      () => mockLocationTrackingRepository.updateDistanceFilter(
        distanceFilter: any(
          named: 'distanceFilter',
          that: inInclusiveRange(9000, 10100),
        ),
      ),
    );
  });

  test('should save locations to the database', () async {
    // act
    await initBackgroundLocationTracking();
    await Future.delayed(const Duration(seconds: 1));

    // assert
    verify(
      () => mockLocationDataRepository.saveLocation(location: tLocations[0]),
    );
    verify(
      () => mockLocationDataRepository.saveLocation(location: tLocations[1]),
    );
    verify(
      () => mockLocationDataRepository.saveLocation(location: tLocations[2]),
    );
    verify(
      () => mockLocationDataRepository.saveLocation(location: tLocations[3]),
    );
  });

  test(
    'should trigger re-initialization of location services if the distance filter timeout is exceeded',
    () async {
      // arrange
      when(
        () => mockLocationTrackingRepository.locationChangeStream(),
      ).thenAnswer(
        (_) =>
            Stream<RecordedLocation>.fromIterable(tSlowSpeedRecordedLocations),
      );

      // act
      await initBackgroundLocationTracking();
      await Future.delayed(const Duration(seconds: 90));

      // assert
      verify(() => mockLocationTrackingRepository.initTracking()).called(2);
    },
    timeout: const Timeout(Duration(seconds: 100)),
  );
}
