/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';

abstract class AuthenticationLocalDataSource {
  const AuthenticationLocalDataSource();

  /// Gets the saved server Info
  ///
  /// Returns:
  /// - [ServerInfo] the saved server info
  ///
  /// Throws:
  /// - [PlatformException]
  /// - [NoSavedServerFailure]
  Future<ServerInfo> getSavedServerInfo();

  /// Removes the saved server
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> removeSavedServer();

  /// Saves the provided server info
  ///
  /// Parameters:
  /// - [ServerInfo] serverInfo
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> saveServerInfo({required ServerInfo serverInfo});

  /// Deletes the local storage
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> deleteLocalStorage();

  /// Deletes the local db cache
  Future<void> deleteLocalDBCache();
}

class AuthLocalDataSourceImpl extends AuthenticationLocalDataSource {
  const AuthLocalDataSourceImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const String _serverUrlKey = 'server_url';
  static const String _anonKey = 'anon_key';

  @override
  Future<ServerInfo> getSavedServerInfo() async {
    final String? serverUrl = await secureStorage.read(key: _serverUrlKey);
    final String? anonKey = await secureStorage.read(key: _anonKey);

    if (serverUrl == null || anonKey == null) {
      throw const NoSavedServerFailure();
    }

    final ServerInfo serverInfo = ServerInfo(url: serverUrl, anonKey: anonKey);

    return serverInfo;
  }

  @override
  Future<void> removeSavedServer() async {
    await secureStorage.delete(key: _serverUrlKey);
    await secureStorage.delete(key: _anonKey);
  }

  @override
  Future<void> saveServerInfo({required ServerInfo serverInfo}) async {
    await secureStorage.write(key: _serverUrlKey, value: serverInfo.url);
    await secureStorage.write(key: _anonKey, value: serverInfo.anonKey);
  }

  @override
  Future<void> deleteLocalDBCache() {
    // TODO: implement deleteLocalDBCache
    throw UnimplementedError();
  }

  @override
  Future<void> deleteLocalStorage() {
    // TODO: implement deleteLocalStorage
    throw UnimplementedError();
  }
}
