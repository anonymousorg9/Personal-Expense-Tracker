import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_tracker/features/transactions/finance_controller.dart';
import 'package:personal_finance_tracker/features/transactions/finance_transaction.dart';

FinanceTransaction transaction({
  required String id,
  required int paise,
  TransactionType type = TransactionType.expense,
  String category = 'Food & dining',
  DateTime? date,
}) {
  return FinanceTransaction(
    id: id,
    title: id,
    category: category,
    amountInPaise: paise,
    type: type,
    date: date ?? DateTime(2026, 1, 1),
  );
}

void main() {
  group('FinanceController', () {
    test('calculates totals and spending by category in paise', () {
      final controller = FinanceController(
        initialTransactions: [
          transaction(
            id: 'salary',
            paise: 5000000,
            type: TransactionType.income,
          ),
          transaction(id: 'food', paise: 125050),
          transaction(id: 'food-2', paise: 50000),
          transaction(id: 'travel', paise: 200000, category: 'Transport'),
        ],
      );

      expect(controller.incomeTotalInPaise, 5000000);
      expect(controller.expenseTotalInPaise, 375050);
      expect(controller.balanceInPaise, 4624950);
      expect(controller.expenseTotalsByCategory, {
        'Food & dining': 175050,
        'Transport': 200000,
      });
    });

    test('adds a transaction and notifies listeners', () {
      final controller = FinanceController();
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.add(transaction(id: 'new', paise: 12345));

      expect(controller.transactions.single.id, 'new');
      expect(controller.expenseTotalInPaise, 12345);
      expect(notifications, 1);
    });

    test('updates an existing transaction and recalculates totals', () {
      final controller = FinanceController(
        initialTransactions: [transaction(id: 'rent', paise: 100000)],
      );
      final updated = transaction(
        id: 'rent',
        paise: 150000,
        type: TransactionType.income,
        category: 'Salary',
      );

      expect(controller.update(updated), isTrue);
      expect(controller.incomeTotalInPaise, 150000);
      expect(controller.expenseTotalInPaise, 0);
    });

    test('deletes existing transactions and ignores unknown IDs', () {
      final controller = FinanceController(
        initialTransactions: [transaction(id: 'coffee', paise: 42000)],
      );

      expect(controller.delete('missing'), isFalse);
      expect(controller.delete('coffee'), isTrue);
      expect(controller.transactions, isEmpty);
      expect(controller.balanceInPaise, 0);
    });

    test('returns transactions newest first as an immutable snapshot', () {
      final controller = FinanceController(
        initialTransactions: [
          transaction(id: 'older', paise: 100, date: DateTime(2026, 1, 1)),
          transaction(id: 'newer', paise: 100, date: DateTime(2026, 2, 1)),
        ],
      );

      expect(controller.transactions.map((item) => item.id), [
        'newer',
        'older',
      ]);
      expect(() => controller.transactions.clear(), throwsUnsupportedError);
    });

    test('rejects non-positive amounts and duplicate IDs', () {
      expect(() => transaction(id: 'zero', paise: 0), throwsArgumentError);
      expect(
        () => FinanceController(
          initialTransactions: [
            transaction(id: 'same', paise: 1),
            transaction(id: 'same', paise: 2),
          ],
        ),
        throwsArgumentError,
      );
    });
  });
}
