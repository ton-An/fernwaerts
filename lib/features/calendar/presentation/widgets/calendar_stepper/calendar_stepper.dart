import 'package:elevated_flex/elevated_flex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';

part '_date_button.dart';
part '_switch.dart';

class CalendarStepper extends StatelessWidget {
  const CalendarStepper({super.key});

  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(LocationHistoryTheme.of(context).radii.medium),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colors.translucentBackground,
          ),
          child: Stack(
            children: [
              ElevatedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Switch(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: () {},
                  ),
                  Elevated(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: height),
                        child: _DateButton()),
                  ),
                  _Switch(
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: () {},
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
