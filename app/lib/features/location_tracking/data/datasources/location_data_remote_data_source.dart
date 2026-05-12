import 'package:drift/drift.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';

/// Remote data source contract for synced location history data.
abstract class LocationDataRemoteDataSource {
  /// Saves a recorded location to the synced local database.
  ///
  /// Parameters:
  /// - location: The [Location] to save
  Future<void> saveLocation({required Location location});

  /// Watches locations recorded within a date range.
  ///
  /// Parameters:
  /// - start: Start [DateTime] of the range
  /// - end: End [DateTime] of the range
  ///
  /// Returns:
  /// - [Stream] of [List]s of [Location]s within the range
  Future<Stream<List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });
}

/// Drift/PowerSync implementation of [LocationDataRemoteDataSource].
class LocationDataRemoteDataSourceImpl implements LocationDataRemoteDataSource {
  const LocationDataRemoteDataSourceImpl({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  @override
  Future<Stream<List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) async {
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    Stream<List<Location>> locationStream =
        (driftDatabase.select(driftDatabase.locations)
              ..where(
                (location) => location.timestamp.isBetween(
                  Variable(start),
                  Variable(end),
                ),
              )
              ..orderBy([(location) => OrderingTerm.asc(location.timestamp)]))
            .watch();

    return locationStream;
  }

  @override
  Future<void> saveLocation({required Location location}) async {
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    await driftDatabase
        .into(driftDatabase.locations)
        .insert(location.toInsertable());
  }
}
