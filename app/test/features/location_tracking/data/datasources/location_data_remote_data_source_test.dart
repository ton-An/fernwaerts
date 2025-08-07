import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late LocationDataRemoteDataSourceImpl locationDataRemoteDataSource;
  late MockSupabaseHandler mockSupabaseHandler;

  late DriftAppDatabase mockDriftDatabase;

  setUp(() async {
    mockSupabaseHandler = MockSupabaseHandler();

    locationDataRemoteDataSource = LocationDataRemoteDataSourceImpl(
      supabaseHandler: mockSupabaseHandler,
    );

    mockDriftDatabase = DriftAppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    when(
      () => mockSupabaseHandler.driftDatabase,
    ).thenAnswer((_) async => mockDriftDatabase);
  });

  tearDown(() async {
    await mockDriftDatabase.close();
  });

  group('getLocationsByDate()', () {
    setUp(() async {
      await mockDriftDatabase
          .into(mockDriftDatabase.locations)
          .insert(tLocations[0].toInsertable());
      await mockDriftDatabase
          .into(mockDriftDatabase.locations)
          .insert(tLocations[1].toInsertable());
    });

    test(
      'should get locations by date range from supabase and return them',
      () async {
        // act
        final result = await locationDataRemoteDataSource.getLocationsByDate(
          start: tStartDate,
          end: tEndDate,
        );

        // assert
        expect(result, [tLocations[1]]);
      },
    );
  });

  group('saveLocation()', () {
    test('should save location to supabase', () async {
      // act
      await locationDataRemoteDataSource.saveLocation(location: tLocations[0]);

      // assert
      final List<Location> locationsInDB =
          await mockDriftDatabase.select(mockDriftDatabase.locations).get();
      expect(locationsInDB, hasLength(1));
    });
  });
}
