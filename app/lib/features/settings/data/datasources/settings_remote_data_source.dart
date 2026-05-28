import 'package:http/http.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

/*
  To-Do:
    - [ ] Test updateEmail once the supabase test suite supports mocking auth
*/

/// {@template settings_remote_data_source}
/// Data source contract for remote settings account-management calls.
///
/// This layer owns Supabase Auth and Edge Function access for updating the
/// current user's credentials, requesting reauthentication, and inviting users.
/// {@endtemplate}
abstract class SettingsRemoteDataSource {
  /// {@macro settings_remote_data_source}
  const SettingsRemoteDataSource();

  /// Updates the email address of the current user.
  ///
  /// Parameters:
  /// - newEmail: [String] new email address to update to
  ///
  /// Throws:
  /// - [AuthException] for Supabase Auth validation or mail delivery errors
  /// - [ClientException] for network or Supabase client transport errors
  Future<void> updateEmail({required String newEmail});

  /// Updates the password of the current user.
  ///
  /// When Supabase requires reauthentication, callers may retry with [otp].
  ///
  /// Parameters:
  /// - newPassword: [String] new password to update to
  /// - otp: [String?] one-time password used for reauthentication
  ///
  /// Throws:
  /// - [AuthException] for Supabase Auth validation or reauthentication errors
  /// - [ClientException] for network or Supabase client transport errors
  Future<void> updatePassword({required String newPassword, String? otp});

  /// Requests an OTP token for reauthentication.
  ///
  /// The token is delivered through the current user's Supabase Auth email
  /// channel.
  ///
  /// Throws:
  /// - [AuthException] for Supabase Auth or email rate-limit errors
  /// - [ClientException] for network or Supabase client transport errors
  Future<void> requestOtp();

  /// Invites a new user to the app through the `invite_user` Edge Function.
  ///
  /// Parameters:
  /// - email: [String] email address of the new user
  ///
  /// Throws:
  /// - [FunctionException] for Edge Function validation or mail delivery errors
  /// - [ClientException] for network or Supabase client transport errors
  Future<void> inviteNewUser({required String email});

  /// Watches the synced public user profiles available to the current user.
  ///
  /// PowerSync sync rules determine whether this contains only the current user
  /// or all users visible through `read.users`.
  ///
  /// Returns:
  /// - [Future] resolving to a [Stream] of [User] lists ordered by username
  ///
  /// Throws:
  /// - Storage or sync exceptions from the underlying database layer
  Future<Stream<List<User>>> watchUsers();
}

/// {@template settings_remote_data_source_impl}
/// Supabase implementation of [SettingsRemoteDataSource].
/// {@endtemplate}
class SettingsRemoteDataSourceImpl extends SettingsRemoteDataSource {
  /// {@macro settings_remote_data_source_impl}
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

  @override
  Future<void> inviteNewUser({required String email}) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.functions.invoke(
      'invite_user',
      body: {'email': email},
    );
  }

  @override
  Future<Stream<List<User>>> watchUsers() async {
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    return (driftDatabase.select(driftDatabase.users)).watch();
  }
}
