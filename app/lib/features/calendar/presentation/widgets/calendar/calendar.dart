import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/decennially_year_calendar/decennially_year_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/monthly_calendar/monthly_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/yearly_calendar/yearly_calendar.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_calendar_container.dart';
part '_calendar_header.dart';
part '_calendar_header_switch.dart';
part '_calendar_type_selector.dart';

enum CalendarSelectionType { customRange, day, week, month, year }

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ExpandableCarouselController _carouselController;
  int _lastOffsetFromCenter = 0;

  static const int _carouselItemCount = 49;
  static const int _carouselCenter = _carouselItemCount ~/ 2 + 1;

  @override
  void initState() {
    super.initState();
    _carouselController = ExpandableCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return _CalendarContainer(
          child: Column(
            children: [
              _CalendarHeader(),
              ExpandableCarousel.builder(
                itemCount: _carouselItemCount,
                itemBuilder: (context, index, realIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.medium,
                    ),
                    child: _buildCalendar(index, selectionTypeState),
                  );
                },
                options: ExpandableCarouselOptions(
                  controller: _carouselController,
                  viewportFraction: 1,
                  initialPage: _carouselCenter,
                  showIndicator: false,
                  autoPlayCurve: Curves.easeOut,
                  onScrolled: (value) {
                    if (value != null && value % 1 == 0) {
                      int offsetFromCenter = value.toInt() - _carouselCenter;
                      if (_lastOffsetFromCenter != offsetFromCenter &&
                          offsetFromCenter != 0) {
                        _showTimeFrameAtOffset(
                          selectionTypeState,
                          offsetFromCenter,
                        );
                        _carouselController.jumpToPage(_carouselCenter);
                        _lastOffsetFromCenter = 0;
                      }
                    }
                  },
                ),
              ),
              XXSmallGap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.medium),
                child: _CalendarTypeSelector(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _buildCalendar(
    int index,
    CalendarSelectionTypeState selectionTypeState,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      return MonthlyCalendar(monthOffset: index - _carouselCenter);
    } else if (selectionTypeState is CalendarMonthSelection) {
      return YearlyCalendar(yearOffset: index - _carouselCenter);
    } else if (selectionTypeState is CalendarYearSelection) {
      return DecenniallyYearCalendar(decadeOffset: index - _carouselCenter);
    }

    return null;
  }

  void _showTimeFrameAtOffset(
    CalendarSelectionTypeState selectionTypeState,
    int offsetFromCenter,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      context.read<MonthlyCalendarCubit>().showMonthAtOffset(offsetFromCenter);
    } else if (selectionTypeState is CalendarMonthSelection) {
      context.read<YearlyCalendarCubit>().showYearAtOffset(offsetFromCenter);
    } else if (selectionTypeState is CalendarYearSelection) {
      context.read<DecenniallyCalendarCubit>().showDecadeAtOffset(
        offsetFromCenter,
      );
    }
  }
}
