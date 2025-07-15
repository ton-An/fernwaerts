import 'dart:io';

/// {@template platform_wrapper}
/// {@macro platform_wrapper}
/// A class that represents PlatformWrapper.
/// {@endtemplate}
class PlatformWrapper {
  const PlatformWrapper();

  bool get isIOS => Platform.isIOS;

  bool get isAndroid => Platform.isAndroid;

  bool get isMacOS => Platform.isMacOS;

  bool get isWindows => Platform.isWindows;

  bool get isLinux => Platform.isLinux;
}
