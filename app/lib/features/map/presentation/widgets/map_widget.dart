import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_history/core/misc/date_time_extensions.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:package_info_plus/package_info_plus.dart';

/* 
  To-Do:
    - [ ] Improve implementation of gradient (include theme etc..)
*/
class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  String? appPackageName;

  final List<LatLng> _points = [];

  @override
  void initState() {
    super.initState();

    _setAppPackageName();

    final CalendarDateSelectionState dateSelectionState =
        context.read<CalendarDateSelectionCubit>().state;

    _loadLocations(dateSelectionState);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [];

    for (int i = 0; i < _points.length; i++) {
      colors.add(
        interpolateColors([
          Colors.purple,
          Colors.blue,
          Colors.teal,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.red,
        ], i / _points.length),
      );
    }

    final List<Marker> markers = [];

    for (int i = 0; i < _points.length - 1; i++) {
      if (_shouldDisplayArrow(point: _points[i], nextPoint: _points[i + 1])) {
        markers.add(
          Marker(
            width: 24,
            height: 24,
            point: _points[i],
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[i],
                    border: Border.all(
                      width: 8,
                      color: colors[i].withValues(alpha: .3),
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                Center(
                  child: Transform.rotate(
                    angle: _calculateAngleToNextPoint(
                      point: _points[i],
                      nextPoint: _points[i + 1],
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return BlocListener<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      listener: (context, dateSelectionState) {
        _loadLocations(dateSelectionState);
      },
      child: BlocListener<MapCubit, MapState>(
        listener: (context, mapState) {
          if (mapState is MapLocationsLoaded) {
            final points = <LatLng>[];

            for (final location in mapState.locations) {
              points.add(
                LatLng(
                  location.latitude.toDouble(),
                  location.longitude.toDouble(),
                ),
              );
            }

            setState(() {
              _points.clear();
              _points.addAll(points);
            });
          }

          if (mapState is MapLocationsError) {
            context.read<InAppNotificationCubit>().sendFailureNotification(
              mapState.failure,
            );
          }
        },
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(50.14568, 9.96024),
            initialZoom: 6,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: appPackageName ?? 'location_history',
            ),
            MarkerLayer(markers: markers.reversed.toList()),
            // ToDo: remove after may 15th + 1 month - keep for debugging until then
            // MarkerLayer(
            //   markers: [
            //     for (int i = 0; i < _points.length; i++)
            //       Marker(
            //         width: 24,
            //         height: 24,
            //         point: _points[i],
            //         child: Padding(
            //           padding: EdgeInsets.only(
            //             top: Random().nextInt(12).toDouble(),
            //           ),
            //           child: Text(i.toString(), style: TextStyle(fontSize: 10)),
            //         ),
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadLocations(
    CalendarDateSelectionState dateSelectionState,
  ) async {
    DateTime? startDate;
    DateTime? endDate;

    if (dateSelectionState is CalendarRangeSelected) {
      startDate = dateSelectionState.startDate;
      endDate = dateSelectionState.endDate;
    } else if (dateSelectionState is CalendarDaySelected) {
      startDate = dateSelectionState.selectedDate;
      endDate = dateSelectionState.selectedDate.endOfDay();
    }

    if (startDate != null && endDate != null) {
      context.read<MapCubit>().loadLocationsByDate(
        start: startDate,
        end: endDate,
      );
    }
  }

  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appPackageName = packageInfo.packageName;
    });
  }

  Color interpolateColors(List<Color> colors, double t) {
    if (colors.isEmpty) throw ArgumentError('Colors list cannot be empty');
    if (colors.length == 1 || t <= 0.0) return colors.first;
    if (t >= 1.0) return colors.last;

    final segmentLength = 1.0 / (colors.length - 1);
    final segmentIndex = (t / segmentLength).floor();
    final localT = (t - (segmentIndex * segmentLength)) / segmentLength;

    final colorStart = colors[segmentIndex];
    final colorEnd = colors[segmentIndex + 1];

    Color color = Color.lerp(colorStart, colorEnd, localT)!;

    return color;
  }

  bool _shouldDisplayArrow({required LatLng point, required LatLng nextPoint}) {
    const Distance distanceUtils = Distance();

    final double distance = distanceUtils.as(
      LengthUnit.Meter,
      point,
      nextPoint,
    );

    const minDistanceInMeters = 10;

    return distance > minDistanceInMeters;
  }

  double _calculateAngleToNextPoint({
    required LatLng point,
    required LatLng nextPoint,
  }) {
    const Distance distanceUtils = Distance();

    // Distance.bearing() gives you the heading clockwise from North, in degrees.
    final double bearingDeg = distanceUtils.bearing(point, nextPoint);

    // Convert degrees → radians for Transform.rotate
    final double bearingRad = bearingDeg * (pi / 180);

    // Normalize to 0 .. 2π
    return (bearingRad + 2 * pi) % (2 * pi);
  }
}
