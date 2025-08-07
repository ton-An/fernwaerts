import 'package:freezed_annotation/freezed_annotation.dart';

part 'supabase_info.freezed.dart';

@freezed
abstract class SupabaseInfo with _$SupabaseInfo {
  const factory SupabaseInfo({required String url, required String anonKey}) =
      _SupabaseInfo;
}
