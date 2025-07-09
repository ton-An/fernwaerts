import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';

@freezed
abstract class ServerInfo with _$ServerInfo {
  const factory ServerInfo({required String url, required String anonKey}) =
      _ServerInfo;
}
