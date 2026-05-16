import 'package:equatable/equatable.dart';

/*
  To-Do:
    - [ ] Add error logging and source ids for failures
*/

/// {@template failure}
/// Base value for recoverable errors returned by repositories and use cases.
///
/// Failures are user- or flow-relevant outcomes, not raw infrastructure
/// exceptions. Repositories convert data-source exceptions into concrete
/// [Failure] subclasses before returning them to domain code.
/// {@endtemplate}
abstract class Failure extends Equatable {
  /// {@macro failure}
  const Failure({
    required this.name,
    required this.message,
    required this.categoryCode,
    required this.code,
  });

  final String name;
  final String message;
  final String categoryCode;
  final String code;

  @override
  List<Object?> get props => [name, message, categoryCode, code];
}
