import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/invite_cubit/invite_states.dart';
import 'package:location_history/features/authentication/presentation/widgets/authentication_form/authentication_form.dart';
import 'package:location_history/features/authentication/presentation/widgets/authentication_page_wrapper/authentication_page_wrapper.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_invite_form.dart';

/*
  To-Do:
    - [ ] Add apple-apple-site-association to fully enable autofill on iOS
    - [ ] Maybe replace custom navigation with GoRouter
*/

class InvitePage extends StatefulWidget {
  /// {@macro authentication_page}
  const InvitePage({super.key, required this.serverUrl});

  static const String pageName = 'invite';
  static const String route = '/$pageName';

  final String serverUrl;

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late ExpandableCarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = ExpandableCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InviteCubit, InviteCubitState>(
      listener: (context, state) {
        if (state is InviteFailure) {
          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }

        if (state is InviteSuccessful) {
          context.go(MapPage.route);
        }
      },
      child: AuthenticationPageWrapper(
        carouselController: _carouselController,
        children: [_InviteForm(serverUrl: widget.serverUrl)],
      ),
    );
  }
}
