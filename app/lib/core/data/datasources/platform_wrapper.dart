import 'dart:io';

/// {@template platform_wrapper}
/// Injectable wrapper around [Platform] checks.
///
/// Use this instead of reading [Platform] directly from repositories or data
/// sources so platform-dependent behavior can be substituted in tests.
/// {@endtemplate}
class PlatformWrapper {
  /// {@macro platform_wrapper}
  const PlatformWrapper();

  bool get isIOS => Platform.isIOS;

  bool get isAndroid => Platform.isAndroid;

  bool get isMacOS => Platform.isMacOS;

  bool get isWindows => Platform.isWindows;

  bool get isLinux => Platform.isLinux;
}
