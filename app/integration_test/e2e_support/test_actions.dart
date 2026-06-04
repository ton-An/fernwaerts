import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'e2e_config.dart';

/// Reusable UI primitives the e2e flows compose on top of.
///
/// Every interactive widget in the auth and settings surface has a stable
/// `Semantics(label: ...)` ancestor, so we drive the UI by semantic label
/// rather than by widget type or text. This insulates the suite from
/// theme/copy changes.

/// Pumps until [matcher] is satisfied, polling every animation frame.
///
/// Use instead of `pumpAndSettle` when the screen contains a steady-state
/// animation (looping video, indeterminate spinner) that would make
/// `pumpAndSettle` time out.
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
  // ignore: avoid_print
  print('[e2e] timeout waiting for $matcher. Current semantic labels:');
  final labels = <String>{};
  for (final element in find.byType(Semantics).evaluate()) {
    final widget = element.widget as Semantics;
    final label = widget.properties.label;
    if (label != null && label.isNotEmpty) labels.add(label);
  }
  for (final label in labels) {
    // ignore: avoid_print
    print('  - "$label"');
  }
  // ignore: avoid_print
  print('[e2e] visible text:');
  for (final element in find.byType(Text).evaluate().take(40)) {
    final t = (element.widget as Text).data;
    if (t != null && t.isNotEmpty) {
      // ignore: avoid_print
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

/// Finds the `Semantics` widget whose [SemanticsProperties.label] matches
/// [label] exactly. Matching widgets directly (rather than via the rendered
/// semantics tree) sidesteps the need for a live SemanticsBinding and works
/// uniformly across all test environments.
Finder findBySemanticLabel(String label) => find.byWidgetPredicate(
  (Widget widget) =>
      widget is Semantics &&
      widget.properties.label == label,
  description: 'Semantics(label: "$label")',
);

/// Taps the widget with the given semantic [label] and settles short
/// animations afterwards.
///
/// The settings stack slides in with animation, so the first frame the widget
/// exists in the tree isn't safe to tap yet (hit-test would land on the
/// moving widget's previous frame). A small pre-tap pump lets that finish.
Future<void> tapSemantic(WidgetTester tester, String label) async {
  await pumpUntil(tester, findBySemanticLabel(label));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.tap(findBySemanticLabel(label).first);
  await tester.pump(const Duration(milliseconds: 100));
}

/// Enters [text] into the editable field nested inside the `Semantics` with
/// the given [label]. The `CustomCupertinoTextField` widgets used across the
/// app wrap a single `EditableText`, so a `descendant` search resolves to a
/// unique target.
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

/// Navigates the app via its real [GoRouter] instance — used to deliver the
/// invite deep link the way Supabase's email redirect would.
void goTo(WidgetTester tester, String location) {
  final context = tester.element(find.byType(Navigator).first);
  GoRouter.of(context).go(location);
}
