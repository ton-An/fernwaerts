import 'package:freezed_annotation/freezed_annotation.dart';

part 'powersync_info.freezed.dart';

/// {@template powersync_info}
/// Connection information for the PowerSync service paired with a server.
/// {@endtemplate}
@freezed
abstract class PowersyncInfo with _$PowersyncInfo {
  /// {@macro powersync_info}
  const factory PowersyncInfo({required String url}) = _PowersyncInfo;
}
