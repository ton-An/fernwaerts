import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/* 
  To-Do:
    - [ ] add docs
*/

class GetLocationsByDate {
  const GetLocationsByDate({
    required this.authenticationRepository,
    required this.locationDataRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationDataRepository locationDataRepository;

  Stream<Either<Failure, List<Location>>> call({
    required DateTime start,
    required DateTime end,
  }) {
    return _getCurrentUserId(start: start, end: end);
  }

  Stream<Either<Failure, List<Location>>> _getCurrentUserId({
    required DateTime start,
    required DateTime end,
  }) async* {
    final Either<Failure, String> userIdEither =
        await authenticationRepository.getCurrentUserId();

    yield* userIdEither.fold(
      (Failure failure) async* {
        yield Left(failure);
      },
      (String userId) async* {
        yield* _getLocationsByDate(start: start, end: end, userId: userId);
      },
    );
  }

  Stream<Either<Failure, List<Location>>> _getLocationsByDate({
    required DateTime start,
    required DateTime end,
    required String userId,
  }) async* {
    final Stream<List<Location>> locationsStream = await locationDataRepository
        .getLocationsByDate(start: start, end: end);

    await for (List<Location> locations in locationsStream) {
      yield Right(locations);
    }
  }
}
