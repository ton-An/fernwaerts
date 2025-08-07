import 'package:drift/drift.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';

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
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    List<Location> locations =
        await (driftDatabase.select(driftDatabase.locations)..where(
          (location) =>
              location.timestamp.isBetween(Variable(start), Variable(end)),
        )).get();

    return locations;
  }

  @override
  Future<void> saveLocation({required Location location}) async {
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    await driftDatabase
        .into(driftDatabase.locations)
        .insert(location.toInsertable());
  }
}
