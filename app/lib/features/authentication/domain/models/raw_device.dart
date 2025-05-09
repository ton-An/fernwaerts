import 'package:equatable/equatable.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';

class RawDevice extends Equatable {
  const RawDevice({
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.os,
    required this.osVersion,
  });

  final String name;
  final String model;
  final String manufacturer;
  final OperatingSystem os;
  final String osVersion;

  @override
  List<Object?> get props => [name, model, manufacturer, os, osVersion];
}
