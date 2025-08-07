import 'dart:async';

import 'package:http/http.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
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

abstract class AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSource();

  /// Checks if the server is reachable.
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<void> isServerConnectionValid({required String serverUrl});

  /// Checks if the server is set up.
  ///
  /// Returns:
  /// - a [bool] indicating if the server is set up.
  ///
  /// Throws:
  /// - [ClientException]
  /// - [PostgrestException]
  Future<bool> isServerSetUp();

  /// Initializes the connection to the supabase server
  ///
  /// Parameters:
  /// - [SupabaseInfo] supabaseInfo: The info of the server to connect to
  Future<void> initializeSupabaseConnection({
    required SupabaseInfo supabaseInfo,
  });

  /// Initializes the connection to the sync server
  ///
  /// Parameters:
  /// - [PowersyncInfo] powersyncInfo: The info of the server to connect to
  Future<void> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  });

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
  /// {@macro server_remote_handler_exceptions}
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
  Future<bool> isSignedIn();

  /// Notifies when the authentication state changes
  ///
  /// Emits:
  /// - An [AuthenticationState]
  Stream<AuthenticationState> authenticationStateStream();

  /// Signs in a user
  ///
  /// Parameters:
  /// - [String] email
  /// - [String] password
  ///
  /// Throws:
  /// - [ClientException]
  /// - [AuthException]
  Future<void> signIn({required String email, required String password});

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the server's Supabase anon key
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
  ///
  /// Returns:
  /// - a [String] containing the Supabase anon key
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<String> getAnonKeyFromServer({required String serverUrl});

  /// Gets the current user's id
  ///
  /// Returns:
  /// - a [String] containing the current user's id
  ///
  /// Throws:
  /// - [NotSignedInFailure]
  Future<String> getCurrentUserId();

  /// Gets the sync server's URL
  ///
  /// Returns:
  /// - [PowersyncInfo] containing the sync server's URL
  Future<PowersyncInfo> getSyncServerInfo();

  /// Checks if the sync server is reachable.
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
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
        yield SignedInState();
      }

      if (authState.event == AuthChangeEvent.signedOut) {
        yield SignedOutState();
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
