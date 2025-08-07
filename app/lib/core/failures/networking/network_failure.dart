import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';
import 'package:location_history/core/failures/networking/server_type.dart';

abstract class NetworkFailure extends Failure {
  NetworkFailure({
    required super.name,
    required super.message,
    required this.serverType,
    required String code,
  }) : super(
         categoryCode: FailureCategoryConstants.networking,
         code: '${serverType.key}_$code',
       );

  final ServerType serverType;

  @override
  List<Object?> get props => [name, message, categoryCode, serverType, code];
}
