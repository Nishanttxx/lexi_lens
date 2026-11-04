import 'package:flutter_test/flutter_test.dart';
import 'package:lexi_lens/main.dart';
import 'package:lexi_lens/widgets/common/app_button.dart';

void main() {
  testWidgets('Lexi Lens app loads and renders new Landing Page at root', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiLensApp());
    await tester.pumpAndSettle();

    // Verify brand and Landing Page elements
    expect(find.text('Lexi Lens'), findsAtLeastNWidgets(1));
    expect(find.text('ASSISTIVE READING PLATFORM'), findsOneWidget);
    expect(find.text('Start exploring'), findsAtLeastNWidgets(1));
    expect(find.text('Read without barriers.\nPowered by AI.'), findsOneWidget);
  });

  testWidgets('Navigating from Landing Page to /app renders existing HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const LexiLensApp());
    await tester.pumpAndSettle();

    // Find and tap 'Start exploring' button
    final startExploringFinder = find.widgetWithText(AppButton, 'Start exploring');
    expect(startExploringFinder, findsAtLeastNWidgets(1));
    await tester.tap(startExploringFinder.first);
    await tester.pumpAndSettle();

    // Verify HomeScreen is now rendered at /app
    expect(find.text('ACCESSIBLE READING TOOLKIT'), findsOneWidget);
  });
}
