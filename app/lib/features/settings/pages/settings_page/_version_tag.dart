part of 'settings_page.dart';

class _VersionTag extends StatefulWidget {
  const _VersionTag();

  @override
  State<_VersionTag> createState() => _VersionTagState();
}

/// A state class that represents versiontag state.
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

/// A button widget that handles smalltext actions.
class SmallTextButton extends StatefulWidget {
  const SmallTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  State<SmallTextButton> createState() => _SmallTextButtonState();
}

/// A state class that represents smalltextbutton state.
class _SmallTextButtonState extends State<SmallTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _didInitAnimation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimation) {
      _fadeController = AnimationController(
        duration: theme.durations.xxTiny,
        reverseDuration: theme.durations.short,
        vsync: this,
      );

      _fadeController.addListener(() {
        setState(() {});
      });

      _fadeAnimation = Tween<double>(begin: 0, end: .08).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        ),
      );

      _didInitAnimation = true;
    } else {
      _fadeController.duration = theme.durations.xxTiny;
      _fadeController.reverseDuration = theme.durations.short;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onTapDown: (_) {
        _fadeController.forward();
      },
      onTapUp: (_) {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
        widget.onPressed();
      },
      onTapCancel: () {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: theme.spacing.xMedium,
              vertical: theme.spacing.xxSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radii.small),
              color: theme.colors.backgroundContrast.withValues(
                alpha: _fadeAnimation.value,
              ),
            ),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: theme.text.body.copyWith(color: theme.colors.hint),
            ),
          ),
        ],
      ),
    );
  }
}
