import 'package:freezed_annotation/freezed_annotation.dart';

part 'powersync_info.freezed.dart';

@freezed
abstract class PowersyncInfo with _$PowersyncInfo {
  const factory PowersyncInfo({required String url}) = _PowersyncInfo;
}
