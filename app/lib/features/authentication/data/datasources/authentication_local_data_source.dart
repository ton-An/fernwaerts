/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationLocalDataSource {
  const AuthenticationLocalDataSource();

  /// Gets the saved server URL.
  ///
  /// Returns:
  /// - [String?] the saved server URL, or [null] if none is found.
  ///
  /// Throws:
  /// - [PlatformException]
  Future<String?> getSavedServerUrl();

  /// Removes the saved server
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> removeSavedServer();

  /// Saves the provided server url
  ///
  /// Parameters:
  /// - [String] serverUrl
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> saveServerUrl({required String serverUrl});
}

class AuthLocalDataSourceImpl extends AuthenticationLocalDataSource {
  const AuthLocalDataSourceImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const String _serverUrlKey = 'server_url';

  @override
  Future<String?> getSavedServerUrl() async {
    final String? serverUrl = await secureStorage.read(key: _serverUrlKey);

    return serverUrl;
  }

  @override
  Future<void> removeSavedServer() async {
    await secureStorage.delete(key: _serverUrlKey);
  }

  @override
  Future<void> saveServerUrl({required String serverUrl}) async {
    await secureStorage.write(key: _serverUrlKey, value: serverUrl);
  }
}
