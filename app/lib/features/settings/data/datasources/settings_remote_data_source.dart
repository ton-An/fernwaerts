import 'package:http/http.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  To-Do:
    - [ ] Test updateEmail once the supabase test suite supports mocking auth
*/

abstract class SettingsRemoteDataSource {
  /// Updates the email address of the current user.
  ///
  /// Parameters:
  /// - [String]: new email address to update to
  ///
  /// Throws:
  /// - [AuthException]
  /// - [ClientException]
  Future<void> updateEmail({required String newEmail});

  /// Updates the password of the current user.
  ///
  /// Parameters:
  /// - [String]: new password to update to
  /// - [String?]: otp token (if required)
  ///
  /// Throws:
  /// - TODO: TBD exceptions
  Future<void> updatePassword({required String newPassword, String? otp});

  /// Requests an OTP token for re-authentication.
  ///
  /// Throws:
  /// - TODO: TBD exceptions
  Future<void> requestOtp();
}

class SettingsRemoteDataSourceImpl extends SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  @override
  Future<void> updateEmail({required String newEmail}) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.updateUser(UserAttributes(email: newEmail));
  }

  @override
  Future<void> requestOtp() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.reauthenticate();
  }

  @override
  Future<void> updatePassword({
    required String newPassword,
    String? otp,
  }) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.updateUser(
      UserAttributes(password: newPassword, nonce: otp),
    );
  }
}
