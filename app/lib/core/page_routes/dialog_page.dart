import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
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
