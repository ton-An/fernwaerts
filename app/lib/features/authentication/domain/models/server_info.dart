import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

part 'server_info.freezed.dart';

@freezed
abstract class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    required SupabaseInfo supabaseInfo,
    required PowersyncInfo powersyncInfo,
  }) = _ServerInfo;
}
