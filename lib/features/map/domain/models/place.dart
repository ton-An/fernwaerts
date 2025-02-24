import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/map/domain/models/address.dart';
import 'package:location_history/features/map/domain/models/coordinate.dart';
import 'package:location_history/features/map/domain/models/location_history_item.dart';

part 'place.freezed.dart';

enum PlaceType {
  groceryStore,
  restaurant,
  park,
  museum,
  other,
}

@freezed
class Place extends LocationHistoryItem with _$Place {
  const factory Place({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required String name,
    required PlaceType type,
    required Coordinate coordinate,
    required Address address,
  }) = _Place;
}
