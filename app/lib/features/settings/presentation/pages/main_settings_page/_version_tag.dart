part of 'main_settings_page.dart';

/// {@template settings_version_tag}
/// Displays the app version and opens the debug page after repeated taps.
/// {@endtemplate}
class _VersionTag extends StatefulWidget {
  /// {@macro settings_version_tag}
  const _VersionTag();

  @override
  State<_VersionTag> createState() => _VersionTagState();
}

class _VersionTagState extends State<_VersionTag> {
  int _tapCount = 0;
  String? _appVersion;

  @override
  void initState() {
    super.initState();

    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    if (_appVersion != null) {
      return SmallTextButton(
        text: _appVersion!,
        onPressed: () {
          _tapCount++;

          if (_tapCount >= 5) {
            context.push(DebugPage.route);
          }
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _appVersion = packageInfo.version;
    });
  }
}
