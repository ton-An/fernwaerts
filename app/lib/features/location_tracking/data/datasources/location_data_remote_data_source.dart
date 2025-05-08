import 'package:brick_core/core.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

abstract class LocationDataRemoteDataSource {
  /// Save location
  ///
  /// Parameters:
  /// - [Location] the location to save
  ///
  /// Throws:
  /// - TBD
  Future<void> saveLocation({required Location location});

  /// Get locations by date range
  ///
  /// Parameters:
  /// - [DateTime] the start date of the range
  /// - [DateTime] the end date of the range
  ///
  /// Returns:
  /// - List of [Location]s within the date range
  ///
  /// Throws:
  /// - TBD
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });
}

class LocationDataRemoteDataSourceImpl implements LocationDataRemoteDataSource {
  const LocationDataRemoteDataSourceImpl({required this.supabaseOfflineFirst});

  final OfflineFirstWithSupabaseRepository supabaseOfflineFirst;

  @override
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) async {
    final String startIsoString = start.toIso8601String();
    final String endIsoString = end.toIso8601String();

    final Query query = Query.where('timestamp', [
      startIsoString,
      endIsoString,
    ], compare: Compare.between);

    final List<Location> locations = await supabaseOfflineFirst.get(
      query: query,
    );

    return locations;
  }

  @override
  Future<void> saveLocation({required Location location}) {
    // TODO: implement saveLocation
    throw UnimplementedError();
  }
}
