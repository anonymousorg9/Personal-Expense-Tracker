import 'package:flutter/material.dart';
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

  testWidgets('named routes open Transactions and Analytics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('transactions-screen-title')), findsOneWidget);

    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('analytics-screen-title')), findsOneWidget);

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Your financial overview'), findsOneWidget);
  });

  testWidgets('transaction form validates, adds, edits, and deletes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-transaction')));
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const Key('save-transaction'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Enter a description.'), findsOneWidget);
    expect(find.text('Enter an amount.'), findsOneWidget);

    final titleField = find.byKey(const Key('transaction-title'));
    await tester.ensureVisible(titleField);
    await tester.enterText(titleField, 'Rent');
    final amountField = find.byKey(const Key('transaction-amount'));
    await tester.ensureVisible(amountField);
    await tester.enterText(amountField, '123.45');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Rent'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').last);
    await tester.pumpAndSettle();
    await tester.enterText(titleField, 'Rent updated');
    await tester.enterText(amountField, '200.00');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Rent updated'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete-transaction')));
    await tester.pumpAndSettle();
    expect(find.text('Rent updated'), findsNothing);
  });
}
