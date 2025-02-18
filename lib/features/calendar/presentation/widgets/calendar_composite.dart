import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/widgets/gaps/gaps.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar/calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_stepper/calendar_stepper.dart';

class CalendarComposite extends StatefulWidget {
  const CalendarComposite({super.key});

  @override
  State<CalendarComposite> createState() => _CalendarCompositeState();
}

class _CalendarCompositeState extends State<CalendarComposite>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _translateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _translateAnimation = Tween<double>(begin: -45, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarExpansionCubit, CalendarExpansionState>(
      listener: (context, state) {
        if (state is CalendarExpanded) {
          _animationController.forward();
        } else if (state is CalendarCollapsed) {
          _animationController.reverse();
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarStepper(),
            if (_animationController.status != AnimationStatus.dismissed)
              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                    offset: Offset(0, _translateAnimation.value),
                    child: Column(
                      children: [
                        MediumGap(),
                        Calendar(),
                      ],
                    )),
              ),
          ],
        );
      },
    );
  }
}
