import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/map/domain/models/address.dart';
import 'package:location_history/features/map/domain/models/coordinate.dart';
import 'package:location_history/features/map/domain/models/location_history_item.dart';

part 'place.freezed.dart';

/// Display category for a stationary place in the map timeline.
enum PlaceType { groceryStore, restaurant, park, museum, other }

/// {@template place}
/// Stationary interval where the user spent time at a named location.
///
/// A [Place] represents a visit on the map timeline. It has one representative
/// coordinate for marker placement and an [Address] for human-readable context.
/// It is a [LocationHistoryItem] so it can be rendered alongside movement
/// [Activity] entries in one chronological history.
/// {@endtemplate}
@freezed
sealed class Place extends LocationHistoryItem with _$Place {
  /// {@macro place}
  ///
  /// Parameters:
  /// - id: [String] stable identifier for this timeline item
  /// - startTime: [DateTime] beginning of the visit interval
  /// - endTime: [DateTime] end of the visit interval
  /// - name: [String] display name for the visited place
  /// - type: [PlaceType] category used for presentation and icon selection
  /// - coordinate: [Coordinate] representative map position for the place
  /// - address: [Address] human-readable address for the place
  const factory Place({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required String name,
    required PlaceType type,
    required Coordinate coordinate,
    required Address address,
  }) = _Place;

  const Place._();
}
