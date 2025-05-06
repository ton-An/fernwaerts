import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/option.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

class LocationDataRepositoryImpl extends LocationDataRepository {
  const LocationDataRepositoryImpl();

  @override
  Future<Either<Failure, List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) {
    // TODO: implement getLocationsByDate
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveLocation({required Location location}) {
    // TODO: implement saveLocation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveMovementSegment({
    required MovementSegment movementSegment,
  }) {
    // TODO: implement saveMovementSegment
    throw UnimplementedError();
  }
}
