import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/location_tracking/data/repository_implementations/location_data_repository_impl.dart';
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

  group('getLocationsByDate', () {
    setUp(() {
      when(
        () => mockLocationDataSource.getLocationsByDate(
          start: any(named: 'start'),
          end: any(named: 'end'),
        ),
      ).thenAnswer((_) async => tLocations);
    });
    test(
      'should get locations by date from remote data source and return them',
      () async {
        // act
        final result = await locationDataRepository.getLocationsByDate(
          start: tStartDate,
          end: tEndDate,
        );

        // assert
        expect(result, tLocations);
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
