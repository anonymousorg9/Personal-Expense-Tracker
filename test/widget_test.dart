import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_tracker/app/app.dart';

void main() {
  testWidgets('Personal Finance Tracker app loads', (tester) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    expect(find.text('Personal Finance Tracker'), findsOneWidget);
  });
}
