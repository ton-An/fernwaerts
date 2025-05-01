import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class Battery {
  const Battery({required this.isCharging, required this.level});

  final bool isCharging;
  final double level;

  static Battery fromBGBattery({required bg.Battery battery}) {
    return Battery(isCharging: battery.isCharging, level: battery.level / 100);
  }
}
