import 'package:freezed_annotation/freezed_annotation.dart';

part 'supabase_info.freezed.dart';

/// {@template supabase_info}
/// Connection information for the Supabase project backing a Fernwaerts server.
/// {@endtemplate}
@freezed
abstract class SupabaseInfo with _$SupabaseInfo {
  /// {@macro supabase_info}
  const factory SupabaseInfo({required String url, required String anonKey}) =
      _SupabaseInfo;
}
