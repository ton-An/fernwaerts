import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

class AcceptInvite {
  const AcceptInvite();

  Future<Either<Failure, None>> call({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }
}
