import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

part 'server_info.freezed.dart';

/// {@template server_info}
/// Saved server connection details required to initialize Supabase and sync.
/// {@endtemplate}
@freezed
abstract class ServerInfo with _$ServerInfo {
  /// {@macro server_info}
  const factory ServerInfo({
    required SupabaseInfo supabaseInfo,
    required PowersyncInfo powersyncInfo,
  }) = _ServerInfo;
}
