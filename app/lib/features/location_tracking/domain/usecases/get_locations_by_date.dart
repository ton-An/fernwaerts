import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

class GetLocationsByDate {
  const GetLocationsByDate({
    required this.authenticationRepository,
    required this.locationDataRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationDataRepository locationDataRepository;

  Future<Either<Failure, List<Location>>> call({
    required DateTime start,
    required DateTime end,
  }) async {
    return _getCurrentUserId(start: start, end: end);
  }

  Future<Either<Failure, List<Location>>> _getCurrentUserId({
    required DateTime start,
    required DateTime end,
  }) async {
    final Either<Failure, String> userIdEither =
        await authenticationRepository.getCurrentUserId();

    return userIdEither.fold(Left.new, (String userId) async {
      return _getLocationsByDate(start: start, end: end, userId: userId);
    });
  }

  Future<Either<Failure, List<Location>>> _getLocationsByDate({
    required DateTime start,
    required DateTime end,
    required String userId,
  }) async {
    final List<Location> locations = await locationDataRepository
        .getLocationsByDate(start: start, end: end);

    return Right(locations);
  }
}
