import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/enums/permission.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

class RequestNecessaryPermissions {
  const RequestNecessaryPermissions({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  static const necessaryPermissions = [
    Permission.location,
    Permission.activityRecognition,
  ];

  Future<Either<Failure, None>> call() async {
    return await authenticationRepository.requestPermissions(
      permissions: necessaryPermissions,
    );
  }
}
