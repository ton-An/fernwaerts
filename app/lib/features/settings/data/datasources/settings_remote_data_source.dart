import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  To-Do:
    - [ ] Test updateEmail once the supabase test suite supports mocking auth
*/

abstract class SettingsRemoteDataSource {
  Future<void> updateEmail({required String newEmail});
}

class SettingsRemoteDataSourceImpl extends SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  @override
  Future<void> updateEmail({required String newEmail}) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.updateUser(UserAttributes(email: newEmail));
  }
}
