import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar/calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_stepper/calendar_stepper.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_layout.dart';
class CalendarComposite extends StatefulWidget {
  const CalendarComposite({super.key});

  @override
  State<CalendarComposite> createState() => _CalendarCompositeState();
}

/// A state class that represents calendarcomposite state.
class _CalendarCompositeState extends State<CalendarComposite>
    with TickerProviderStateMixin {
  late AnimationController _translateController;
  late AnimationController _fadeController;

  late Animation<double> _translateAnimation;
  late Animation<double> _fadeAnimation;

  bool _didInitAnimations = false;

  CalendarSelectionTypeState? _lastSelectionTypeState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimations) {
      _initTranslateAnimation(theme: theme);
      _initFadeAnimation(theme: theme);

      _didInitAnimations = true;
    } else {
      _updateControllerDurations(theme: theme);
    }
  }

  @override
  void dispose() {
    _translateController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      listener: (context, CalendarSelectionTypeState selectionTypeState) {
        _handleSelectionTypeState(selectionTypeState: selectionTypeState);
      },
      builder: (context, CalendarSelectionTypeState selectionTypeState) {
        return BlocConsumer<CalendarExpansionCubit, CalendarExpansionState>(
          listener: (context, expansionState) {
            _handleCalendarExpansionState(
              expansionState: expansionState,
              selectionTypeState: selectionTypeState,
            );
          },
          builder: (context, state) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                WebfabrikTheme.of(context).radii.medium,
              ),
              child: _Layout(
                itemSpacing: WebfabrikTheme.of(context).spacing.medium,
                calendarOffset: _translateAnimation.value,
                children: [
                  const CalendarStepper(),

                  if (_shouldDisplayCalendar())
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Calendar(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _initTranslateAnimation({required WebfabrikThemeData theme}) {
    _translateController = AnimationController(
      vsync: this,
      duration: theme.durations.xxShort,
      reverseDuration: theme.durations.xxMedium,
    );

    _translateController.addListener(() {
      setState(() {});
    });

    _translateAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _translateController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  void _initFadeAnimation({required WebfabrikThemeData theme}) {
    _fadeController = AnimationController(
      vsync: this,
      duration: theme.durations.medium,
      reverseDuration: theme.durations.short,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  void _updateControllerDurations({required WebfabrikThemeData theme}) {
    _translateController.duration = theme.durations.xxShort;
    _translateController.reverseDuration = theme.durations.xxMedium;

    _fadeController.duration = theme.durations.medium;
    _fadeController.reverseDuration = theme.durations.short;
  }

  void _handleSelectionTypeState({
    required CalendarSelectionTypeState selectionTypeState,
  }) {
    final DateTime? selectionStart = _getStartDateOfSelection(context);
    if (selectionStart != null) {
      if (!(_lastSelectionTypeState is CalendarRangeSelection ||
              _lastSelectionTypeState is CalendarDaySelection ||
              _lastSelectionTypeState is CalendarWeekSelection) &&
          (selectionTypeState is CalendarRangeSelection ||
              selectionTypeState is CalendarDaySelection ||
              selectionTypeState is CalendarWeekSelection)) {
        context.read<MonthlyCalendarCubit>().showMonth(selectionStart);
      } else if (selectionTypeState is CalendarMonthSelection) {
        context.read<YearlyCalendarCubit>().showYear(selectionStart);
      } else if (selectionTypeState is CalendarYearSelection) {
        context.read<DecenniallyCalendarCubit>().showDecade(selectionStart);
      }
    }

    _lastSelectionTypeState = selectionTypeState;
  }

  void _handleCalendarExpansionState({
    required CalendarExpansionState expansionState,
    required CalendarSelectionTypeState selectionTypeState,
  }) {
    if (expansionState is CalendarCollapsed) {
      _translateController.reverse();
      _fadeController.reverse();
    }

    if (expansionState is CalendarExpanded) {
      _translateController.forward();
      _fadeController.forward();

      final bool hasShiftedSelection =
          context.read<CalendarDateSelectionCubit>().hasShiftedSelection;

      if (hasShiftedSelection) {
        final DateTime? selectionStart = _getStartDateOfSelection(context);

        if (selectionStart != null) {
          if (selectionTypeState is CalendarRangeSelection ||
              selectionTypeState is CalendarDaySelection ||
              selectionTypeState is CalendarWeekSelection) {
            context.read<MonthlyCalendarCubit>().showMonth(selectionStart);
          } else if (selectionTypeState is CalendarMonthSelection) {
            context.read<YearlyCalendarCubit>().showYear(selectionStart);
          } else if (selectionTypeState is CalendarYearSelection) {
            context.read<DecenniallyCalendarCubit>().showDecade(selectionStart);
          }
        }
      }

      context.read<CalendarDateSelectionCubit>().resetHasShiftedSelection();
    }
  }

  DateTime? _getStartDateOfSelection(BuildContext context) {
    final CalendarDateSelectionState dateSelectionState =
        context.read<CalendarDateSelectionCubit>().state;

    if (dateSelectionState is CalendarDaySelected) {
      return dateSelectionState.selectedDate;
    } else {
      return (dateSelectionState as CalendarRangeSelected).startDate;
    }
  }

  bool _shouldDisplayCalendar() =>
      !(_translateController.status == AnimationStatus.dismissed &&
          _fadeController.status == AnimationStatus.dismissed);
}
