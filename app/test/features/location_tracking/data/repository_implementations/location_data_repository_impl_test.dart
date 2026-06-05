import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/location_tracking/data/repository_implementations/location_data_repository_impl.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late LocationDataRepositoryImpl locationDataRepository;
  late MockLocationDataRemoteDataSource mockLocationDataSource;
  late ActivitySegment tActivitySegment;

  setUp(() {
    mockLocationDataSource = MockLocationDataRemoteDataSource();
    locationDataRepository = LocationDataRepositoryImpl(
      locationRemoteDataSource: mockLocationDataSource,
    );
    tActivitySegment = ActivitySegment(
      startLocation: tLocations[0],
      endLocation: tLocations[1],
      activityType: tLocations[1].activityType,
    );
  });

  setUpAll(() {
    registerFallbackValue(tLocations[0]);
    registerFallbackValue(
      ActivitySegment(
        startLocation: tLocations[0],
        endLocation: tLocations[1],
        activityType: tLocations[1].activityType,
      ),
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
      final result = await locationDataRepository.saveLocation(
        location: tLocations[0],
      );

      // assert
      expect(result, const Right(None()));
      verify(
        () => mockLocationDataSource.saveLocation(location: tLocations[0]),
      );
    });

    test(
      'should convert Postgres write exceptions to StorageWriteFailure',
      () async {
        // arrange
        when(
          () => mockLocationDataSource.saveLocation(
            location: any(named: 'location'),
          ),
        ).thenThrow(tPostgresException);

        // act
        final result = await locationDataRepository.saveLocation(
          location: tLocations[0],
        );

        // assert
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });

  group('saveActivitySegment', () {
    setUp(() {
      when(
        () => mockLocationDataSource.saveActivitySegment(
          activitySegment: any(named: 'activitySegment'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should save activity segment to remote data source', () async {
      // act
      final result = await locationDataRepository.saveActivitySegment(
        activitySegment: tActivitySegment,
      );

      // assert
      expect(result, const Right(None()));
      verify(
        () => mockLocationDataSource.saveActivitySegment(
          activitySegment: tActivitySegment,
        ),
      );
    });

    test(
      'should convert Postgres write exceptions to StorageWriteFailure',
      () async {
        // arrange
        when(
          () => mockLocationDataSource.saveActivitySegment(
            activitySegment: any(named: 'activitySegment'),
          ),
        ).thenThrow(tPostgresException);

        // act
        final result = await locationDataRepository.saveActivitySegment(
          activitySegment: tActivitySegment,
        );

        // assert
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });
}
