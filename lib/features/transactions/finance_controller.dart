import 'package:flutter/foundation.dart';

import 'finance_transaction.dart';

/// Shared in-memory transaction state for the finance tracker.
///
/// A fresh controller is empty. Use [FinanceController.withDemoData] when the
/// UI should start with clearly identified demonstration transactions.
class FinanceController extends ChangeNotifier {
  FinanceController({
    Iterable<FinanceTransaction> initialTransactions = const [],
    this.isDemoData = false,
  }) : _transactions = List<FinanceTransaction>.of(initialTransactions) {
    _validateUniqueIds(_transactions);
  }

  factory FinanceController.withDemoData() {
    return FinanceController(
      initialTransactions: _demoTransactions,
      isDemoData: true,
    );
  }

  final bool isDemoData;
  final List<FinanceTransaction> _transactions;

  /// Transactions ordered newest first, returned as an immutable snapshot.
  List<FinanceTransaction> get transactions {
    final sorted = List<FinanceTransaction>.of(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return List<FinanceTransaction>.unmodifiable(sorted);
  }

  int get incomeTotalInPaise => _totalFor(TransactionType.income);

  int get expenseTotalInPaise => _totalFor(TransactionType.expense);

  int get balanceInPaise => incomeTotalInPaise - expenseTotalInPaise;

  Map<String, int> get expenseTotalsByCategory {
    final totals = <String, int>{};
    for (final transaction in _transactions) {
      if (!transaction.isIncome) {
        totals.update(
          transaction.category,
          (total) => total + transaction.amountInPaise,
          ifAbsent: () => transaction.amountInPaise,
        );
      }
    }
    return Map<String, int>.unmodifiable(totals);
  }

  void add(FinanceTransaction transaction) {
    if (_indexOf(transaction.id) != -1) {
      throw ArgumentError.value(
        transaction.id,
        'transaction.id',
        'Transaction IDs must be unique.',
      );
    }
    _transactions.add(transaction);
    notifyListeners();
  }

  bool update(FinanceTransaction transaction) {
    final index = _indexOf(transaction.id);
    if (index == -1) return false;
    _transactions[index] = transaction;
    notifyListeners();
    return true;
  }

  bool delete(String id) {
    final index = _indexOf(id);
    if (index == -1) return false;
    _transactions.removeAt(index);
    notifyListeners();
    return true;
  }

  int _totalFor(TransactionType type) {
    return _transactions
        .where((transaction) => transaction.type == type)
        .fold<int>(
          0,
          (total, transaction) => total + transaction.amountInPaise,
        );
  }

  int _indexOf(String id) => _transactions.indexWhere((item) => item.id == id);

  static void _validateUniqueIds(List<FinanceTransaction> transactions) {
    final ids = <String>{};
    for (final transaction in transactions) {
      if (!ids.add(transaction.id)) {
        throw ArgumentError.value(
          transaction.id,
          'initialTransactions',
          'Transaction IDs must be unique.',
        );
      }
    }
  }
}

final List<FinanceTransaction> _demoTransactions = [
  FinanceTransaction(
    id: 'demo-salary',
    title: 'Monthly salary',
    category: 'Salary',
    amountInPaise: 4500000,
    type: TransactionType.income,
    date: DateTime(2026, 10, 1),
  ),
  FinanceTransaction(
    id: 'demo-groceries',
    title: 'Groceries',
    category: 'Groceries',
    amountInPaise: 245000,
    type: TransactionType.expense,
    date: DateTime(2026, 10, 18),
  ),
  FinanceTransaction(
    id: 'demo-electricity',
    title: 'Electricity bill',
    category: 'Bills & utilities',
    amountInPaise: 185000,
    type: TransactionType.expense,
    date: DateTime(2026, 10, 14),
  ),
  FinanceTransaction(
    id: 'demo-coffee',
    title: 'Coffee',
    category: 'Food & dining',
    amountInPaise: 42000,
    type: TransactionType.expense,
    date: DateTime(2026, 10, 19),
  ),
];
