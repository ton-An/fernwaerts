/*
  To-Do:
    - [ ] Standardize error handling and server calls
*/

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

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
  const AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.supabaseHandler,
  });

  final FlutterSecureStorage secureStorage;
  final SupabaseHandler supabaseHandler;

  static const String _serverUrlKey = 'server_url';
  static const String _anonKey = 'anon_key';
  static const String _powersyncUrlKey = 'powersync_url';

  @override
  Future<ServerInfo> getSavedServerInfo() async {
    final String? serverUrl = await secureStorage.read(key: _serverUrlKey);
    final String? anonKey = await secureStorage.read(key: _anonKey);
    final String? powersyncUrl = await secureStorage.read(
      key: _powersyncUrlKey,
    );

    if (serverUrl == null || anonKey == null || powersyncUrl == null) {
      throw const NoSavedServerFailure();
    }

    final ServerInfo serverInfo = ServerInfo(
      supabaseInfo: SupabaseInfo(url: serverUrl, anonKey: anonKey),
      powersyncInfo: PowersyncInfo(url: powersyncUrl),
    );

    return serverInfo;
  }

  @override
  Future<void> removeSavedServer() async {
    await secureStorage.delete(key: _serverUrlKey);
    await secureStorage.delete(key: _anonKey);
    await secureStorage.delete(key: _powersyncUrlKey);
  }

  @override
  Future<void> saveServerInfo({required ServerInfo serverInfo}) async {
    await secureStorage.write(
      key: _serverUrlKey,
      value: serverInfo.supabaseInfo.url,
    );
    await secureStorage.write(
      key: _anonKey,
      value: serverInfo.supabaseInfo.anonKey,
    );
    await secureStorage.write(
      key: _powersyncUrlKey,
      value: serverInfo.powersyncInfo.url,
    );
  }

  @override
  Future<void> deleteLocalDBCache() async {
    // final PsBackendConnector psBackendConnector =
    //     await supabaseHandler.psBackendConnector;

    // await psBackendConnector.powersyncDb.
  }

  @override
  Future<void> deleteLocalStorage() async {
    await secureStorage.deleteAll();
  }
}
