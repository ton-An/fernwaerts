import 'package:flutter/material.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class CustomSegmentedControlItem<T> {
  const CustomSegmentedControlItem({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}

class CustomSegmentedControl<T> extends StatelessWidget {
  const CustomSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<CustomSegmentedControlItem<T>> items;
  final T selectedValue;
  final Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    final int selectedIndex =
        items.indexWhere((item) => item.value == selectedValue);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.colors.backgroundContrast.withAlpha(20),
        borderRadius: BorderRadius.circular(
          theme.radii.small,
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment(
              -1 + (2 * selectedIndex / (items.length - 1)),
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / items.length,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(
                    theme.radii.small,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onChanged(items[i].value);
                    },
                    child: Center(
                        child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      style: theme.text.footnote.copyWith(
                        fontWeight: i == selectedIndex
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: i == selectedIndex
                            ? theme.colors.background
                            : theme.colors.hint,
                      ),
                      child: Text(
                        items[i].label,
                      ),
                    )),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
