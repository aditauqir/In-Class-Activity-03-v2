import 'package:flutter_test/flutter_test.dart';

import 'package:inclass_act03/main.dart';

void main() {
  testWidgets('Cyber-Tactile Deck initial state and button interaction test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TactileDeckApp());

    // Verify initial dashboard values
    expect(find.text('WEATHER COMMAND CENTER'), findsOneWidget);
    expect(find.text('TOTAL TAPS'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('65%'), findsWidgets);
    expect(find.text('STATUS: READY'), findsOneWidget);

    // Verify persona buttons are present
    expect(find.text('SUN'), findsOneWidget);
    expect(find.text('RAIN'), findsOneWidget);
    expect(find.text('WIND'), findsOneWidget);
    expect(find.text('STORM'), findsOneWidget);

    // Tap the SUN tactile button
    await tester.tap(find.text('SUN'));
    await tester.pumpAndSettle();

    // Verify tap count incremented and status updated
    expect(find.text('1'), findsOneWidget);
    expect(find.text('STATUS: SUNNY CONDITIONS ACTIVATED'), findsOneWidget);
  });
}
