import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/// {@template get_locations_by_date}
/// Gets the current user's locations within a date range.
///
/// Parameters:
/// - start: [DateTime] to start the range at
/// - end: [DateTime] to end the range at
///
/// Returns:
/// - [Stream] of [Either] values containing [Failure]s or [List]s of
///   [Location]s in the range
///
/// Failures:
/// - [NotSignedInFailure]
/// {@endtemplate}
class GetLocationsByDate {
  /// {@macro get_locations_by_date}
  const GetLocationsByDate({
    required this.authenticationRepository,
    required this.locationDataRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationDataRepository locationDataRepository;

  /// {@macro get_locations_by_date}
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
