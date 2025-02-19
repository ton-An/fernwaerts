part of 'monthly_calendar.dart';

enum _DayCellType {
  unselected,
  selected,
  rangeStart,
  rangeEnd,
  inRange,
  filler,
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.type,
  });

  final DateTime date;
  final _DayCellType type;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return GestureDetector(
          onTap: () {
            context
                .read<CalendarDateSelectionCubit>()
                .selectDate(date, selectionTypeState);
          },
          child: Stack(
            children: [
              _buildRangeUnderlay(theme),
              Container(
                decoration: BoxDecoration(
                  color: _getCellBackground(theme),
                  borderRadius: BorderRadius.circular(theme.radii.small),
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: _getTextStyle(theme),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRangeUnderlay(LocationHistoryThemeData theme) {
    BorderRadius? borderRadius;
    Color? color;

    if (type == _DayCellType.rangeStart) {
      borderRadius = BorderRadius.horizontal(
        left: Radius.circular(theme.radii.small),
      );
    } else if (type == _DayCellType.rangeEnd) {
      borderRadius = BorderRadius.horizontal(
        right: Radius.circular(theme.radii.small),
      );
    }

    if (type == _DayCellType.inRange ||
        type == _DayCellType.rangeStart ||
        type == _DayCellType.rangeEnd) {
      color = theme.colors.primary.withValues(alpha: .2);
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }

  Color? _getCellBackground(LocationHistoryThemeData theme) {
    if (type == _DayCellType.selected ||
        type == _DayCellType.rangeStart ||
        type == _DayCellType.rangeEnd) {
      return theme.colors.primary;
    }

    return null;
  }

  TextStyle _getTextStyle(LocationHistoryThemeData theme) {
    late Color color;
    FontWeight? fontWeight;

    if (type == _DayCellType.selected ||
        type == _DayCellType.rangeStart ||
        type == _DayCellType.rangeEnd) {
      color = theme.colors.background;
      fontWeight = FontWeight.bold;
    } else {
      if (type == _DayCellType.filler) {
        color = theme.colors.hint;
      } else {
        color = theme.colors.text;
      }
    }
    return theme.text.body.copyWith(fontWeight: fontWeight, color: color);
  }
}
