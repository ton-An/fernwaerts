import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';
import 'package:location_history/features/authentication/presentation/widgets/authentication_form/authentication_form.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
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
    - [ ] Add apple-apple-site-association to fully enable autofill on iOS
*/

enum AuthenticationFormType { signIn, adminSignUp }

/// {@template authentication_page}
/// The main page for handling user authentication.
///
/// This page manages different authentication flows including:
/// - Welcome screen
/// - Server URL input
/// - Sign in
/// - Initial admin sign up
///
/// It uses an [ExpandableCarousel] to navigate between these different
/// authentication steps and responds to state changes from the [AuthenticationCubit].
/// A video background is displayed for visual appeal.
/// {@endtemplate}
class AuthenticationPage extends StatefulWidget {
  /// {@macro authentication_page}
  const AuthenticationPage({super.key});

  static const String pageName = 'authentication';
  static const String route = '/$pageName';

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late ExpandableCarouselController _carouselController;

  AuthenticationFormType _formType = AuthenticationFormType.signIn;

  @override
  void initState() {
    super.initState();

    _carouselController = ExpandableCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocListener<AuthenticationCubit, AuthenticationCubitState>(
      listener: (BuildContext context, AuthenticationCubitState state) {
        _handleAuthState(authState: state, theme: theme);
      },
      child: Stack(
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
                    items: [
                      const _Welcome(),
                      const _ServerUrlForm(),
                      if (_formType == AuthenticationFormType.adminSignUp)
                        const _AdminSignUpForm()
                      else
                        const _SignInForm(),
                    ],
                    options: ExpandableCarouselOptions(
                      controller: _carouselController,
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
      ),
    );
  }

  /// Responds to changes in authentication state by navigating or displaying errors.
  ///
  /// - If entering server details, animates to server URL page.
  /// - If entering login or admin sign-up info, sets form type and animates to form page.
  /// - On successful login or sign-up, finalizes autofill and navigates to [MapPage].
  /// - On error, sends a failure notification via [InAppNotificationCubit].
  void _handleAuthState({
    required AuthenticationCubitState authState,
    required WebfabrikThemeData theme,
  }) {
    if (authState is EnterServerDetails) {
      _animateToPage(pageIndex: 1, theme: theme);
    }

    if (authState is EnterLogInInfo) {
      _setFormType(formType: AuthenticationFormType.signIn);
      _animateToPage(pageIndex: 2, theme: theme);
    }

    if (authState is EnterAdminSignUpInfo) {
      _setFormType(formType: AuthenticationFormType.adminSignUp);
      _animateToPage(pageIndex: 2, theme: theme);
    }

    if (authState is AuthenticationSuccessful) {
      TextInput.finishAutofillContext();
      context.go(MapPage.route);
    }

    if (authState is AuthenticationFailure) {
      context.read<InAppNotificationCubit>().sendFailureNotification(
        authState.failure,
      );
    }
  }

  /// Updates the form type (sign-in or admin sign-up) and triggers a rebuild.
  void _setFormType({required AuthenticationFormType formType}) {
    setState(() => _formType = formType);
  }

  /// Animates the carousel to the given page index with a smooth curve.
  ///
  /// Uses [ExpandableCarouselController] to switch pages over [theme.durations.medium].
  void _animateToPage({
    required int pageIndex,
    required WebfabrikThemeData theme,
  }) {
    _carouselController.animateToPage(
      pageIndex,
      duration: theme.durations.medium,
      curve: Curves.easeInOut,
    );
  }
}
