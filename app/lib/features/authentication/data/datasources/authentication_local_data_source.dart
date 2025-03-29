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
  /// Failures:
  /// - [StorageWriteFailure]
  Future<void> removeSavedServer();
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
}
