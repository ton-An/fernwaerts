import 'package:flutter/material.dart';

/// {@template dialog_page}
/// A page that displays dialog content.
/// {@endtemplate}
class DialogPage<T> extends Page<T> {
/// {@macro dialog_page}
  const DialogPage({required this.builder});

  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
    context: context,
    settings: this,
    builder: builder,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    useSafeArea: false,
  );
}
