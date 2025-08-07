import 'package:equatable/equatable.dart';

/*
  To-Do:
    - [ ] Add error logging and source ids for failures
*/

abstract class Failure extends Equatable {
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
