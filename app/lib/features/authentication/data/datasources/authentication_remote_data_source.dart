import 'dart:async';

import 'package:http/http.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/failures/authentication/expired_refresh_token_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/core/misc/url_path_constants.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

/// {@template authentication_remote_data_source}
/// Remote auth data source contract for Supabase, bootstrap, and sync setup.
///
/// This layer owns network calls, Supabase auth/session access, Supabase Edge
/// Function calls, and PowerSync initialization.
/// {@endtemplate}
abstract class AuthenticationRemoteDataSource {
  /// {@macro authentication_remote_data_source}
  const AuthenticationRemoteDataSource();

  /// Checks whether the Supabase server health endpoint is reachable.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the Supabase server to check
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<void> isServerConnectionValid({required String serverUrl});

  /// Checks whether the configured server completed first-run setup.
  ///
  /// The Supabase connection must already be initialized.
  ///
  /// Returns:
  /// - [bool] whether the server is set up
  ///
  /// Throws:
  /// - [ClientException]
  /// - [PostgrestException]
  Future<bool> isServerSetUp();

  /// Initializes the Supabase connection for the selected server.
  ///
  /// Existing Supabase and PowerSync resources may be disposed before the new
  /// connection is initialized.
  ///
  /// Parameters:
  /// - supabaseInfo: [SupabaseInfo] connection info for the Supabase server
  Future<void> initializeSupabaseConnection({
    required SupabaseInfo supabaseInfo,
  });

  /// Initializes the PowerSync connection for the selected server.
  ///
  /// The Supabase connection must already be initialized so PowerSync can use
  /// the same authenticated server context.
  ///
  /// Parameters:
  /// - powersyncInfo: [PowersyncInfo] connection info for the sync server
  Future<void> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  });

  /// Creates the initial admin account during first-run server setup.
  ///
  /// This calls the unauthenticated bootstrap endpoint and is only valid before
  /// the instance has been set up.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the server to bootstrap
  /// - username: [String] username for the admin user
  /// - email: [String] email for the admin user
  /// - password: [String] password for the admin user
  ///
  /// Throws:
  /// - [WeakPasswordFailure]
  /// {@macro server_remote_handler_exceptions}
  Future<void> signUpInitialAdmin({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  });

  /// Completes setup for the currently authenticated invited user.
  ///
  /// The Supabase client must already hold the invited user's temporary
  /// session from the invite link.
  ///
  /// Parameters:
  /// - username: [String] username for the invited user
  /// - password: [String] password for the invited user
  ///
  /// Throws:
  /// - [ClientException]
  /// - [FunctionException]
  Future<void> signUpInvitedUser({
    required String username,
    required String password,
  });

  /// Recovers the invited user's temporary session from an invite refresh token.
  ///
  /// Parameters:
  /// - refreshToken: [String] refresh token from the Supabase invite callback
  ///
  /// Throws:
  /// - [AuthException]
  /// - [ExpiredRefreshTokenFailure]
  /// - [ClientException]
  Future<void> recoverInviteSession({required String refreshToken});

  /// Checks whether the configured Supabase client has an active session.
  ///
  /// Returns:
  /// - [bool] whether a current session exists
  Future<bool> isSignedIn();

  /// Streams sign-in and sign-out events from the configured auth client.
  ///
  /// Emits:
  /// - An [AuthenticationState]
  Stream<AuthenticationState> authenticationStateStream();

  /// Signs in a user against the initialized Supabase auth connection.
  ///
  /// Parameters:
  /// - email: [String] email address for the user
  /// - password: [String] password for the user
  ///
  /// Throws:
  /// - [ClientException]
  /// - [AuthException]
  Future<void> signIn({required String email, required String password});

  /// Signs out the current user from the initialized Supabase auth connection.
  Future<void> signOut();

  /// Gets the server's Supabase anon key from the bootstrap endpoint.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the server to query
  ///
  /// Returns:
  /// - [String] containing the Supabase anon key
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<String> getAnonKeyFromServer({required String serverUrl});

  /// Gets the currently signed-in Supabase user's id.
  ///
  /// Returns:
  /// - [String] containing the current user's id
  ///
  /// Throws:
  /// - [NotSignedInFailure]
  Future<String> getCurrentUserId();

  /// Gets the currently signed-in Supabase user's email.
  ///
  /// Returns:
  /// - [String] containing the current user's email
  ///
  /// Throws:
  /// - [NotSignedInFailure]
  Future<String> getCurrentUserEmail();

  /// Gets the sync server URL from the configured Supabase Edge Function.
  ///
  /// Returns:
  /// - [PowersyncInfo] containing the sync server's URL
  ///
  /// Throws:
  /// - [ClientException]
  /// - [FunctionException]
  Future<PowersyncInfo> getSyncServerInfo();

  /// Checks whether the PowerSync server health endpoint is reachable.
  ///
  /// Parameters:
  /// - syncServerUrl: [String] URL of the sync server to check
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<void> isSyncServerConnectionValid({required String syncServerUrl});
}

class AuthRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required this.serverRemoteHandler,
    required this.supabaseHandler,
    required this.talker,
  });

  final ServerRemoteHandler serverRemoteHandler;
  final SupabaseHandler supabaseHandler;
  final Talker talker;

  @override
  Future<bool> isServerSetUp() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final queryResult =
        await supabaseClient
            .from('public_info')
            .select()
            .eq('name', 'is_set_up')
            .single();

    final bool isSetUp = queryResult['value'];

    return isSetUp;
  }

  @override
  Future<void> isServerConnectionValid({required String serverUrl}) async {
    await serverRemoteHandler.get(
      url: Uri.parse(serverUrl + UrlPathConstants.supabaseHealth),
      serverType: ServerType.supabase,
    );
  }

  @override
  Future<void> initializeSupabaseConnection({
    required SupabaseInfo supabaseInfo,
  }) async {
    try {
      await supabaseHandler.dispose();
    } catch (_) {}

    await supabaseHandler.initializeSupabase(supabaseInfo: supabaseInfo);
  }

  @override
  Future<void> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  }) async {
    await supabaseHandler.initializePowerSync(powersyncInfo: powersyncInfo);
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
      serverType: ServerType.supabase,
    );

    if (response == null) {
      return;
    }

    if (response['error']['code'] == 'weak_password') {
      throw const WeakPasswordFailure();
    }
  }

  @override
  Future<void> signUpInvitedUser({
    required String username,
    required String password,
  }) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.functions.invoke(
      'sign_up_invited_user',
      body: {'username': username, 'password': password},
    );
  }

  @override
  Future<void> recoverInviteSession({required String refreshToken}) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final AuthResponse authResponse = await supabaseClient.auth.setSession(
      refreshToken,
    );
    final Session? session = authResponse.session;

    if (session == null) {
      throw const ExpiredRefreshTokenFailure();
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final Session? currentSession = supabaseClient.auth.currentSession;

    talker.info('Has session: ${currentSession?.accessToken != 'null'}');
    talker.info('Expires at: ${currentSession?.expiresAt}');

    if (currentSession != null) {
      return true;
    }

    return false;
  }

  @override
  Stream<AuthenticationState> authenticationStateStream() async* {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final Stream<AuthState> authStateSubscription =
        supabaseClient.auth.onAuthStateChange;

    await for (AuthState authState in authStateSubscription) {
      if (authState.event == AuthChangeEvent.signedIn) {
        yield const SignedInState();
      }

      if (authState.event == AuthChangeEvent.signedOut) {
        yield const SignedOutState();
      }
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    await supabaseClient.auth.signOut();
  }

  @override
  Future<String> getAnonKeyFromServer({required String serverUrl}) async {
    final Map<String, dynamic>? response = await serverRemoteHandler.get(
      url: Uri.parse(serverUrl + UrlPathConstants.getAnonKey),
      serverType: ServerType.supabase,
    );

    final String anonKey = response!['data']['anon_key'];

    return anonKey;
  }

  @override
  Future<String> getCurrentUserId() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final User? currentUser = supabaseClient.auth.currentUser;

    if (currentUser == null) {
      throw const NotSignedInFailure();
    }

    final String currentUserId = currentUser.id;

    return currentUserId;
  }

  @override
  Future<String> getCurrentUserEmail() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final String? email = supabaseClient.auth.currentUser?.email;

    if (email == null) {
      throw const NotSignedInFailure();
    }

    return email;
  }

  @override
  Future<PowersyncInfo> getSyncServerInfo() async {
    final SupabaseClient supabaseClient = await supabaseHandler.client;

    final FunctionResponse response = await supabaseClient.functions.invoke(
      'get_sync_server_url',
    );

    final String syncServerUrl = response.data['data']['sync_server_url'];

    final PowersyncInfo powersyncInfo = PowersyncInfo(url: syncServerUrl);

    return powersyncInfo;
  }

  @override
  Future<void> isSyncServerConnectionValid({
    required String syncServerUrl,
  }) async {
    await serverRemoteHandler.get(
      url: Uri.parse(syncServerUrl + UrlPathConstants.powersyncHealth),
      serverType: ServerType.syncServer,
    );
  }
}
