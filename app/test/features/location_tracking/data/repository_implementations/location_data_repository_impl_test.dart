import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/location_tracking/data/repository_implementations/location_data_repository_impl.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late LocationDataRepositoryImpl locationDataRepository;
  late MockLocationDataRemoteDataSource mockLocationDataSource;

  setUp(() {
    mockLocationDataSource = MockLocationDataRemoteDataSource();
    locationDataRepository = LocationDataRepositoryImpl(
      locationRemoteDataSource: mockLocationDataSource,
    );
  });

  setUpAll(() {
    registerFallbackValue(tLocations[0]);
  });

  group('getLocationsByDate', () {
    late StreamController<List<Location>> tLocationsStreamController;
    setUp(() {
      tLocationsStreamController = StreamController();
      tLocationsStreamController.add(tLocations);

      when(
        () => mockLocationDataSource.getLocationsByDate(
          start: any(named: 'start'),
          end: any(named: 'end'),
        ),
      ).thenAnswer((_) async => tLocationsStreamController.stream);
    });

    test(
      'should get locations by date from remote data source and return them',
      () async {
        // act
        final stream = await locationDataRepository.getLocationsByDate(
          start: tStartDate,
          end: tEndDate,
        );

        // assert
        await expectLater(stream, emits(tLocations));
        verify(
          () => mockLocationDataSource.getLocationsByDate(
            start: tStartDate,
            end: tEndDate,
          ),
        );
      },
    );
  });

  group('saveLocation', () {
    setUp(() {
      when(
        () => mockLocationDataSource.saveLocation(
          location: any(named: 'location'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should save location to remote data source', () async {
      // act
      await locationDataRepository.saveLocation(location: tLocations[0]);

      // assert
      verify(
        () => mockLocationDataSource.saveLocation(location: tLocations[0]),
      );
    });
  });
}
