import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

abstract class LocationDataRemoteDataSource {
  /// Save location
  ///
  /// Parameters:
  /// - [Location] the location to save
  Future<void> saveLocation({required Location location});

  /// Get locations by date range
  ///
  /// Parameters:
  /// - [DateTime] the start date of the range
  /// - [DateTime] the end date of the range
  ///
  /// Returns:
  /// - List of [Location]s within the date range
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });
}

class LocationDataRemoteDataSourceImpl implements LocationDataRemoteDataSource {
  const LocationDataRemoteDataSourceImpl({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  @override
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) async {
    final OfflineFirstWithSupabaseRepository supabaseOfflineFirst =
        await supabaseHandler.supabaseOfflineFirst;

    // final String startIsoString = start.toIso8601StringWithTz();
    // final String endIsoString = end.toIso8601StringWithTz();

    // final Query query = Query.where('timestamp', [
    //   start,
    //   end,
    // ], compare: Compare.between);

    final List<Location> locations = await supabaseOfflineFirst.get<Location>(
      // query: query,
    );

    return locations;
  }

  @override
  Future<void> saveLocation({required Location location}) async {
    final OfflineFirstWithSupabaseRepository supabaseOfflineFirst =
        await supabaseHandler.supabaseOfflineFirst;

    await supabaseOfflineFirst.upsert<Location>(location);
  }
}
