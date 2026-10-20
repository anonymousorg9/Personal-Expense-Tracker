import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:personal_finance_tracker/app/app.dart';
import 'package:personal_finance_tracker/features/transactions/finance_controller.dart';
import 'package:personal_finance_tracker/features/transactions/transactions_screen.dart';

void main() {
  testWidgets('empty transactions state loads its local illustration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FinanceController(),
        child: const MaterialApp(home: TransactionsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('empty-transactions-illustration')),
      findsOneWidget,
    );
    expect(find.text('No transactions yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personal Finance Tracker dashboard renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    expect(find.text('FINTRACK · PERSONAL FINANCE'), findsOneWidget);
    expect(find.text('Your financial overview'), findsOneWidget);
    expect(find.text('Net balance'), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const Key('dashboard-balance-value')))
          .data,
      '\u20B940,280.00',
    );
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Net result'), findsOneWidget);

    final dashboardScroll = find
        .descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(Scrollable),
        )
        .first;
    final spendingInsight = find.textContaining(
      'Groceries is the largest recorded spending category',
    );
    await tester.scrollUntilVisible(
      spendingInsight,
      240,
      scrollable: dashboardScroll,
    );
    expect(spendingInsight, findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Spending overview'),
      240,
      scrollable: dashboardScroll,
    );
    expect(find.text('Spending overview'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Recent transactions'),
      240,
      scrollable: dashboardScroll,
    );
    expect(find.text('Recent transactions'), findsOneWidget);
    expect(find.text('Monthly salary'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
  });

  testWidgets('dashboard adapts navigation at mobile and desktop widths', (
    WidgetTester tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 695);

    await tester.pumpWidget(const PersonalFinanceApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('FinTrack'), findsNothing);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1242, 761);
    await tester.pumpAndSettle();

    expect(find.text('FinTrack'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard totals update from a saved transaction', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PersonalFinanceApp());

    expect(
      tester.widget<Text>(find.byKey(const Key('summary-value-expenses'))).data,
      '\u20B94,720.00',
    );

    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('transaction-title')), 'Books');
    await tester.enterText(find.byKey(const Key('transaction-amount')), '100');
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<Text>(find.byKey(const Key('dashboard-balance-value')))
          .data,
      '\u20B940,180.00',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('summary-value-expenses'))).data,
      '\u20B94,820.00',
    );
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
