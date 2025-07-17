import 'dart:io';

class PlatformWrapper {
  const PlatformWrapper();

  bool get isIOS => Platform.isIOS;

  bool get isAndroid => Platform.isAndroid;

  bool get isMacOS => Platform.isMacOS;

  bool get isWindows => Platform.isWindows;

  bool get isLinux => Platform.isLinux;
}
