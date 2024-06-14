import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pawsportion/main.dart';

void main() {
  testWidgets('Portion increments and decrements test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PawsPortionFeederApp());

    // Verify that our initial portion starts at 12.
    expect(find.text('12'), findsOneWidget);
    expect(find.text('13'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add_circle));  
    await tester.pump();

    // Verify that our portion has incremented.
    expect(find.text('12'), findsNothing);
    expect(find.text('13'), findsOneWidget);

    // Tap the '-' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.remove_circle));
    await tester.pump();

    // Verify that our portion has decremented back to 12.
    expect(find.text('13'), findsNothing);
    expect(find.text('12'), findsOneWidget);
  });
}
