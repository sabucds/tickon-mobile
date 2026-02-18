import 'package:flutter_test/flutter_test.dart';
import 'package:tickon/main.dart';

void main() {
  testWidgets('app launches without error', (tester) async {
    await tester.pumpWidget(const TickonApp());
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
