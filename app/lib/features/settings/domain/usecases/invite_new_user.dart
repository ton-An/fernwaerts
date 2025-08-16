import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';

class InviteNewUser {
  const InviteNewUser({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  Future<Either<Failure, None>> call({required String email}) async {
    return await settingsRepository.inviteNewUser(email: email);
  }
}
