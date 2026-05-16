import 'package:elevated_flex/elevated_flex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_date_button.dart';
part '_navigation_button.dart';

/// {@template calendar_stepper}
/// Shows the current calendar selection and lets users step through it.
///
/// The previous and next buttons call
/// [CalendarDateSelectionCubit.shiftSelection] to move the selected day, range,
/// week, month, or year. The center date button displays the current selection
/// and toggles [CalendarExpansionCubit].
///
/// Interactions:
/// - Previous/next shifts the current selection backward or forward.
/// - Date button expands or collapses the full calendar picker.
///
/// Sub-components:
/// - [_NavigationButton]: Previous and next controls.
/// - [_DateButton]: Current selection label and expansion toggle.
/// {@endtemplate}
class CalendarStepper extends StatelessWidget {
  /// {@macro calendar_stepper}
  const CalendarStepper({super.key});

  /// The fixed height of the calendar stepper.
  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        WebfabrikTheme.of(context).radii.medium,
      ),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: Container(
          decoration: BoxDecoration(color: theme.colors.translucentBackground),
          child: Stack(
            children: [
              ElevatedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavigationButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: () {
                      context.read<CalendarDateSelectionCubit>().shiftSelection(
                        forward: false,
                      );
                    },
                  ),
                  const Elevated(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: height),
                      child: _DateButton(),
                    ),
                  ),
                  _NavigationButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: () {
                      context.read<CalendarDateSelectionCubit>().shiftSelection(
                        forward: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
