import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/data/datasources/supabase_offline_first.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

class GetLocationData {
  const GetLocationData({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  Future<Either<Failure, List<Location>>> call() async {
    final List<Location> locationList =
        await SupabaseOfflineFirst().get<Location>();

    return Right(locationList);
  }
}
