import 'package:brick_supabase/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/brick/brick.g.dart';
import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mock_supabase_offline_first_repository.dart';

void main() {
  late LocationDataRemoteDataSourceImpl locationDataRemoteDataSource;
  late SupabaseMockServer mockSupabaseServer;
  late MockSupabaseOfflineFirstRepository mockSupabaseOfflineFirstRepository;

  setUp(() async {
    mockSupabaseServer = SupabaseMockServer(
      modelDictionary: supabaseModelDictionary,
    );
    await mockSupabaseServer.setUp();
    mockSupabaseOfflineFirstRepository =
        MockSupabaseOfflineFirstRepository.configure(
          mockSupabaseServer: mockSupabaseServer,
        );
    await mockSupabaseOfflineFirstRepository.initialize();
    locationDataRemoteDataSource = LocationDataRemoteDataSourceImpl(
      supabaseOfflineFirst: mockSupabaseOfflineFirstRepository,
    );
  });

  tearDown(() async {
    await mockSupabaseServer.tearDown();
    await mockSupabaseOfflineFirstRepository.reset();
  });

  group('getLocationsByDate()', () {
    setUp(() async {
      const request = SupabaseRequest<Location>();
      final response = SupabaseResponse([
        await mockSupabaseServer.serialize(tLocations[0]),
        await mockSupabaseServer.serialize(tLocations[1]),
      ]);
      mockSupabaseServer.handle({request: response});
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
    setUp(() async {
      mockSupabaseServer.handle({});
    });
    test('should save location to supabase', () async {
      // act
      await locationDataRemoteDataSource.saveLocation(location: tLocations[0]);

      // assert
      final List<Location> locationsInDB =
          await mockSupabaseOfflineFirstRepository.get<Location>();
      expect(locationsInDB, hasLength(1));
    });
  });
}
