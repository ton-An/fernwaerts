import 'package:flutter/cupertino.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/core/widgets/custom_cupertino_text_button.dart';
import 'package:location_history/core/widgets/custom_cupertino_text_field.dart';
import 'package:location_history/core/widgets/gaps/gaps.dart';
import 'package:location_history/features/authentication/presentation/widgets/authentication_form.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:video_player/video_player.dart';

part '_server_url_form.dart';
part '_sign_in_form.dart';
part '_video_background.dart';
part '_welcome.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  static const String pageName = "authentication";
  static const String route = "/$pageName";

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late ExpandableCarouselController _carouselController;

  @override
  void initState() {
    super.initState();

    _carouselController = ExpandableCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return Stack(
      children: [
        Positioned.fill(child: _VideoBackground()),
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
                  items: [
                    // Container(
                    //   color: Colors.red,
                    //   width: double.infinity,
                    //   height: 300,
                    // ),
                    // Container(
                    //   color: Colors.green,
                    //   width: double.infinity,
                    //   height: 400,
                    // ),
                    _Welcome(),
                    _ServerUrlForm(),
                    _SignInForm(),
                  ],
                  options: ExpandableCarouselOptions(
                    controller: _carouselController,
                    viewportFraction: 1,
                    showIndicator: false,
                    padEnds: false,
                    disableCenter: true,
                    autoPlayCurve: Curves.easeOut,
                    // physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
