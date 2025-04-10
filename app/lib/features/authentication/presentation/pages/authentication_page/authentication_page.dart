import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';
import 'package:location_history/features/authentication/presentation/widgets/authentication_form.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:video_player/video_player.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_admin_sign_up_form.dart';
part '_server_url_form.dart';
part '_sign_in_form.dart';
part '_video_background.dart';
part '_welcome.dart';

/*
  To-Do:
    - [ ] Add loading animations (to the buttons)
    - [ ] Add apple-apple-site-association to fully enable autofill on iOS
*/

enum AuthenticationFormType { logIn, adminSignUp }

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  static const String pageName = 'authentication';
  static const String route = '/$pageName';

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late ExpandableCarouselController _carouselController;

  AuthenticationFormType _formType = AuthenticationFormType.logIn;

  @override
  void initState() {
    super.initState();

    _carouselController = ExpandableCarouselController();
  }

  void _animateToPage(int pageIndex) {
    _carouselController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 420),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return BlocListener<AuthenticationCubit, AuthenticationCubitState>(
      listener: (context, state) {
        if (state is EnterServerDetails) {
          _animateToPage(1);
        }

        if (state is EnterLogInInfo) {
          setState(() {
            _formType = AuthenticationFormType.logIn;
          });
          _animateToPage(2);
        }

        if (state is EnterAdminSignUpInfo) {
          setState(() {
            _formType = AuthenticationFormType.adminSignUp;
          });
          _animateToPage(2);
        }

        if (state is LogInSuccessful || state is AdminSignUpSuccessful) {
          TextInput.finishAutofillContext();
          context.go(MapPage.route);
        }

        if (state is AuthenticationError) {
          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }
      },
      child: Stack(
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
                      _Welcome(),
                      _ServerUrlForm(),
                      if (_formType == AuthenticationFormType.adminSignUp)
                        _AdminSignUpForm()
                      else
                        _SignInForm(),
                    ],
                    options: ExpandableCarouselOptions(
                      controller: _carouselController,
                      expansionAlignment: Alignment.bottomCenter,
                      viewportFraction: 1,
                      showIndicator: false,
                      padEnds: false,
                      disableCenter: true,
                      physics: NeverScrollableScrollPhysics(),
                      autoPlayCurve: Curves.easeOut,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
