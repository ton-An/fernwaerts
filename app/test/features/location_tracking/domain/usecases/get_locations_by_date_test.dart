import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late GetLocationsByDate getLocationsByDate;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockLocationDataRepository mockLocationDataRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockLocationDataRepository = MockLocationDataRepository();
    getLocationsByDate = GetLocationsByDate(
      authenticationRepository: mockAuthenticationRepository,
      locationDataRepository: mockLocationDataRepository,
    );
  });

  setUp(() {
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Right(tUserId));

    when(
      () => mockLocationDataRepository.getLocationsByDate(
        start: any(named: 'start'),
        end: any(named: 'end'),
      ),
    ).thenAnswer((_) async => Right(tLocations));
  });

  test('should get the users id', () async {
    // act
    await getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the users id', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    expect(result, const Left(StorageReadFailure()));
  });

  test('should get locations by date from location data repository', () async {
    // act
    await getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    verify(
      () => mockLocationDataRepository.getLocationsByDate(
        start: tStartDate,
        end: tEndDate,
      ),
    );
  });
  test('should relay failures from getting locations by date', () async {
    // arrange
    when(
      () => mockLocationDataRepository.getLocationsByDate(
        start: tStartDate,
        end: tEndDate,
      ),
    ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

    // act
    final result = await getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });
}
