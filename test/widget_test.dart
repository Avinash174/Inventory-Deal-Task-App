import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_deal_app/main.dart';
import 'package:inventory_deal_app/core/utils/service_locator.dart' as di;

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize service locator
    await di.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we are on the login screen or loading
    expect(find.text('Investor Deal'), findsOneWidget);
  });
}
