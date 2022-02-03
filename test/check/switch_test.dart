import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastSwitch', (WidgetTester tester) async {
    const titleText = 'title';

    await tester.pumpWidget(buildMaterialTestApp(
      const FastSwitch(name: 'switch', titleText: titleText),
    ));

    expect(find.byType(FastSwitch), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text(titleText), findsOneWidget);
  });

  testWidgets('updates FastSwitch', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      const FastSwitch(name: 'switch', titleText: 'title'),
    ));

    final state = tester.state(find.byType(FastSwitch)) as FastSwitchState;

    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(state.value, !state.widget.initialValue!);
  });

  testWidgets('validates FastSwitch', (WidgetTester tester) async {
    const errorText = 'Must be switched on';

    await tester.pumpWidget(buildMaterialTestApp(
      FastSwitch(
        name: 'switch',
        titleText: 'title',
        initialValue: true,
        validator: (value) => value! ? null : errorText,
      ),
    ));

    final state = tester.state(find.byType(FastSwitch)) as FastSwitchState;

    final errorTextFinder = find.text(errorText);
    expect(errorTextFinder, findsNothing);

    state.didChange(false);
    await tester.pumpAndSettle();

    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('adapts FastSwitch to Android', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(buildMaterialTestApp(
      const FastSwitch(name: 'switch', titleText: 'title', adaptive: true),
    ));

    expect(find.byType(SwitchListTile), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('adapts FastSwitch to iOS', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(buildCupertinoTestApp(
      const FastSwitch(name: 'switch', adaptive: true, titleText: 'title'),
    ));

    expect(find.byType(CupertinoFormRow), findsOneWidget);
    expect(find.byType(CupertinoSwitch), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
