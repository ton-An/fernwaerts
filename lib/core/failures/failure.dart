abstract class Failure {
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
}
