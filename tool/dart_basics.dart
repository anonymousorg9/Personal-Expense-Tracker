// ignore_for_file: avoid_print

const _rupee = '\u20B9';

class LedgerEntry {
  const LedgerEntry({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String category;
  final double amount;
  final bool isIncome;
}

double totalAmount(Iterable<LedgerEntry> entries, {required bool income}) {
  return entries
      .where((entry) => entry.isIncome == income)
      .fold<double>(0, (total, entry) => total + entry.amount);
}

String formatRupees(double amount) => '$_rupee${amount.toStringAsFixed(2)}';

void main() {
  const openingBalance = 12000.0;
  var transactionCount = 0;

  final entries = <LedgerEntry>[
    const LedgerEntry(
      title: 'Monthly salary',
      category: 'Salary',
      amount: 45000,
      isIncome: true,
    ),
    const LedgerEntry(
      title: 'Groceries',
      category: 'Groceries',
      amount: 2450,
      isIncome: false,
    ),
    const LedgerEntry(
      title: 'Electricity bill',
      category: 'Bills & utilities',
      amount: 1850,
      isIncome: false,
    ),
    const LedgerEntry(
      title: 'Coffee',
      category: 'Food & dining',
      amount: 420,
      isIncome: false,
    ),
  ];

  transactionCount = entries.length;
  final income = totalAmount(entries, income: true);
  final expenses = totalAmount(entries, income: false);
  final balance = openingBalance + income - expenses;

  final categories = <String>{};
  final expensesByCategory = <String, double>{};
  for (final entry in entries) {
    categories.add(entry.category);
    if (!entry.isIncome) {
      expensesByCategory.update(
        entry.category,
        (amount) => amount + entry.amount,
        ifAbsent: () => entry.amount,
      );
    }
  }

  final rankedExpenses = expensesByCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final largestCategory = rankedExpenses.first;
  final balanceStatus = switch (balance) {
    < 0 => 'negative',
    0 => 'balanced',
    _ => 'positive',
  };

  print('Dart basics demonstration: ledger summary');
  print('Demo data: yes (sample entries)');
  print('Transactions: $transactionCount');
  print('Income: ${formatRupees(income)}');
  print('Expenses: ${formatRupees(expenses)}');
  print(
    'Net balance after opening balance ${formatRupees(openingBalance)}: '
    '${formatRupees(balance)}',
  );
  print('Unique categories: ${categories.length}');
  print('Expenses by category:');
  for (final category in expensesByCategory.keys.toList()..sort()) {
    print('- $category: ${formatRupees(expensesByCategory[category]!)}');
  }
  print(
    'Largest spending category: ${largestCategory.key} '
    '(${(largestCategory.value / expenses * 100).round()}% of spending)',
  );
  print('Balance status: $balanceStatus');
}
