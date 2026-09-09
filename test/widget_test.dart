import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_tracker/app/app.dart';

void main() {
  testWidgets('Personal Finance Tracker dashboard renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    expect(find.text('Good morning, Adithya'), findsOneWidget);
    expect(find.text('Your financial overview'), findsOneWidget);
    expect(find.text('Total balance'), findsOneWidget);
    expect(find.text('\u20B984,250'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Savings'), findsOneWidget);
    expect(find.text('Spending overview'), findsOneWidget);
    expect(find.text('Recent transactions'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
  });
}