import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

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

  late StreamController<List<Location>> tLocationsStreamController;

  setUp(() {
    tLocationsStreamController = StreamController();
    tLocationsStreamController.add(tLocations);

    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Right(tUserId));

    when(
      () => mockLocationDataRepository.getLocationsByDate(
        start: any(named: 'start'),
        end: any(named: 'end'),
      ),
    ).thenAnswer((_) async => tLocationsStreamController.stream);
  });

  test('should get the users id', () async {
    // act
    final stream = getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    await expectLater(stream, emits(Right(tLocations)));
    verify(() => mockAuthenticationRepository.getCurrentUserId());
  });

  test('should relay failures from getting the users id', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getCurrentUserId(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final stream = getLocationsByDate(start: tStartDate, end: tEndDate);

    // assert
    await expectLater(stream, emits(Left(StorageReadFailure())));
  });

  test(
    'should get locations by date from location repo and return them as a stream',
    () async {
      // act
      final stream = getLocationsByDate(start: tStartDate, end: tEndDate);

      // assert
      await expectLater(stream, emits(Right(tLocations)));

      verify(
        () => mockLocationDataRepository.getLocationsByDate(
          start: tStartDate,
          end: tEndDate,
        ),
      );
    },
  );
}
