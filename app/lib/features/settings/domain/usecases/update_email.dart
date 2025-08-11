import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

class UpdateEmail {
  UpdateEmail({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  Future<Either<Failure, None>> call({required String newEmail}) {
    return settingsRepository.updateEmail(newEmail: newEmail);
  }
}
