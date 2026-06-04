// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'e2e_config.dart';

/// Pumps while animations may be active, unlike `pumpAndSettle`.
Future<void> pumpUntil(
  WidgetTester tester,
  Finder matcher, {
  Duration timeout = E2EConfig.networkTimeout,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (matcher.evaluate().isNotEmpty) {
      return;
    }
  }
  print('[e2e] timeout waiting for $matcher. Current semantic labels:');
  final labels = <String>{};
  for (final element in find.byType(Semantics).evaluate()) {
    final widget = element.widget as Semantics;
    final label = widget.properties.label;
    if (label != null && label.isNotEmpty) labels.add(label);
  }
  for (final label in labels) {
    print('  - "$label"');
  }
  print('[e2e] visible text:');
  for (final element in find.byType(Text).evaluate().take(40)) {
    final t = (element.widget as Text).data;
    if (t != null && t.isNotEmpty) {
      print('  - "$t"');
    }
  }
  fail('Timed out waiting for $matcher to appear');
}

Future<void> pumpUntilGone(
  WidgetTester tester,
  Finder matcher, {
  Duration timeout = E2EConfig.networkTimeout,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (matcher.evaluate().isEmpty) {
      return;
    }
  }
  fail('Timed out waiting for $matcher to disappear');
}

/// Finds widgets by their stable app semantics labels.
Finder findBySemanticLabel(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is Semantics && widget.properties.label == label,
  description: 'Semantics(label: "$label")',
);

/// Waits for a semantic target before tapping through animated settings views.
Future<void> tapSemantic(WidgetTester tester, String label) async {
  await pumpUntil(tester, findBySemanticLabel(label));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.tap(findBySemanticLabel(label).first);
  await tester.pump(const Duration(milliseconds: 100));
}

/// Types into the editable field wrapped by a semantic label.
Future<void> enterTextInto(
  WidgetTester tester,
  String label,
  String text,
) async {
  await pumpUntil(tester, findBySemanticLabel(label));
  final field = find.descendant(
    of: findBySemanticLabel(label),
    matching: find.byType(EditableText),
  );
  expect(field, findsOneWidget, reason: 'No EditableText under "$label"');
  await tester.enterText(field, text);
  await tester.pump(const Duration(milliseconds: 50));
}

/// Clears a visible notification through the UI instead of DI internals.
Future<void> dismissNotificationIfPresent(
  WidgetTester tester,
  String label,
) async {
  final notification = findBySemanticLabel(label);
  if (notification.evaluate().isEmpty) return;

  await tester.fling(notification.first, const Offset(0, -300), 1000);
  await tester.pump(const Duration(milliseconds: 300));
}

/// Delivers deep links to the app router inside the running test app.
void goTo(WidgetTester tester, String location) {
  final context = tester.element(find.byType(Navigator).first);
  GoRouter.of(context).go(location);
}
