import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/misc/url_path_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

abstract class AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSource();

  /// Checks if the server is reachable.
  ///
  /// Throws:
  /// - [ClientException]
  /// - [ArgumentError]
  /// - [FormatException]
  /// - [PostgrestException]
  Future<void> isServerConnectionValid();

  /// Checks if the server is set up.
  ///
  /// Parameters:
  /// - [Uri] serverUrl: The URL of the server to check.
  ///
  /// Returns:
  /// - a [bool] indicating if the server is set up.
  ///
  /// Throws:
  /// - [ClientException]
  /// - [PostgrestException]
  Future<bool> isServerSetUp();

  /// Initializes the connection to the server
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to.
  Future<void> initializeServerConnection({required String serverUrl});

  /// Signs up the initial admin user
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
  /// - [String] username: The username of the admin user
  /// - [String] email: The email of the admin user
  /// - [String] password: The password of the admin user
  ///
  /// Throws:
  /// - [WeakPasswordFailure]
  /// - [UnknownRequestFailure]
  /// - [DioException]
  Future<void> signUpInitialAdmin({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  });

  /// Checks if the user is signed in
  ///
  /// Returns:
  /// - a [bool] indicating if the user is signed in
  bool isSignedIn();
}

class AuthRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required this.serverRemoteHandler,
    required this.supabaseHandler,
  });

  final ServerRemoteHandler serverRemoteHandler;
  final SupabaseHandler supabaseHandler;

  @override
  Future<bool> isServerSetUp() async {
    final SupabaseClient supabaseClient = supabaseHandler.getClient();

    final queryResult =
        await supabaseClient
            .from('public_settings')
            .select()
            .eq('name', 'is_set_up')
            .single();

    final bool isSetUp = queryResult['value'];

    return isSetUp;
  }

  @override
  Future<void> isServerConnectionValid() async {
    final SupabaseClient supabaseClient = supabaseHandler.getClient();

    await supabaseClient.from('public_settings').select().single();
  }

  @override
  Future<void> initializeServerConnection({required String serverUrl}) async {
    try {
      await supabaseHandler.dispose();
    } catch (_) {}

    await supabaseHandler.initialize(serverUrl: serverUrl);
  }

  @override
  Future<void> signUpInitialAdmin({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await serverRemoteHandler.post(
      url: Uri.parse(serverUrl + UrlPathConstants.signUpInitialAdmin),
      body: {'username': username, 'email': email, 'password': password},
    );

    if (response == null) {
      return;
    }

    if (response['error']['code'] == 'weak_password') {
      throw WeakPasswordFailure();
    }
  }

  @override
  bool isSignedIn() {
    final SupabaseClient supabaseClient = supabaseHandler.getClient();

    final Session? currentSession = supabaseClient.auth.currentSession;

    if (currentSession != null) {
      return true;
    }

    return false;
  }
}
