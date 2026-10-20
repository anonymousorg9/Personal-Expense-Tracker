import 'package:flutter/material.dart';

import '../features/analytics/analytics_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/transactions/finance_transaction.dart';
import '../features/transactions/transaction_form_screen.dart';
import '../features/transactions/transactions_screen.dart';

abstract final class AppRouter {
  static const dashboard = '/';
  static const transactions = '/transactions';
  static const analytics = '/analytics';
  static const transactionForm = '/transactions/form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      dashboard => const DashboardScreen(),
      transactions => const TransactionsScreen(),
      analytics => const AnalyticsScreen(),
      transactionForm => TransactionFormScreen(
        transaction: settings.arguments is FinanceTransaction
            ? settings.arguments! as FinanceTransaction
            : null,
      ),
      _ => _UnknownRouteScreen(routeName: settings.name),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({required this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text('No page is registered for ${routeName ?? ''}.'),
      ),
    );
  }
}
