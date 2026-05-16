import 'package:drift/drift.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';

/// {@template location_data_remote_data_source}
/// Data source contract for persisted, synced location history data.
///
/// This layer owns Drift/PowerSync access for the raw location points table and
/// maps rows to domain [Location] values.
/// {@endtemplate}
abstract class LocationDataRemoteDataSource {
  /// {@macro location_data_remote_data_source}
  const LocationDataRemoteDataSource();

  /// Saves a recorded location to the synced local database.
  ///
  /// The saved row is later uploaded by PowerSync according to the configured
  /// sync rules.
  ///
  /// Parameters:
  /// - location: [Location] to save
  ///
  /// Throws:
  /// - Storage or sync exceptions from the underlying database layer
  Future<void> saveLocation({required Location location});

  /// Watches locations recorded within a date range.
  ///
  /// The range is inclusive and emitted values are ordered by timestamp from
  /// oldest to newest.
  ///
  /// Parameters:
  /// - start: [DateTime] to start the range at
  /// - end: [DateTime] to end the range at
  ///
  /// Returns:
  /// - [Future] that resolves to a [Stream] of [List]s of [Location]s within
  ///   the range
  ///
  /// Throws:
  /// - Storage or sync exceptions from the underlying database layer
  Future<Stream<List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });
}

/// {@template location_data_remote_data_source_impl}
/// Drift/PowerSync implementation of [LocationDataRemoteDataSource].
/// {@endtemplate}
class LocationDataRemoteDataSourceImpl implements LocationDataRemoteDataSource {
  /// {@macro location_data_remote_data_source_impl}
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
