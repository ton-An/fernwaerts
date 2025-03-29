/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationLocalDataSource {
  const AuthenticationLocalDataSource();

  /// Checks if there is a saved server connection.
  ///
  /// Returns:
  /// - a [bool] indicating if there is a saved server connection.
  ///
  /// Throws:
  /// - [PlatformException]
  Future<bool> hasServerConnectionSaved();
}

class AuthLocalDataSourceImpl extends AuthenticationLocalDataSource {
  const AuthLocalDataSourceImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  Future<bool> hasServerConnectionSaved() async {
    final String? serverUrl = await secureStorage.read(key: 'server_url');

    if (serverUrl != null) {
      return true;
    } else {
      return false;
    }
  }
}
