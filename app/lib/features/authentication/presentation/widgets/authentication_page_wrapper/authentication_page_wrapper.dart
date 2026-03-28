import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_video_background.dart';

class AuthenticationPageWrapper extends StatelessWidget {
  const AuthenticationPageWrapper({
    super.key,
    required this.children,
    required this.carouselController,
  });

  static const String pageName = 'authentication';
  static const String route = '/$pageName';

  final List<Widget> children;
  final ExpandableCarouselController carouselController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Stack(
      children: [
        const Positioned.fill(child: _VideoBackground()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(theme.radii.xLarge),
            ),
            child: BackdropFilter(
              filter: theme.misc.blurFilter,
              child: Container(
                color: theme.colors.translucentBackground,
                child: ExpandableCarousel(
                  items: children,
                  options: ExpandableCarouselOptions(
                    controller: carouselController,
                    expansionAlignment: Alignment.bottomCenter,
                    viewportFraction: 1,
                    showIndicator: false,
                    padEnds: false,
                    disableCenter: true,
                    physics: const NeverScrollableScrollPhysics(),
                    autoPlayCurve: Curves.easeOut,
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 240,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
