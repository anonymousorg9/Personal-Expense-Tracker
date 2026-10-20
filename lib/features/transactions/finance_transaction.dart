/// The direction of money movement for a finance transaction.
enum TransactionType { income, expense }

/// Categories available to the demo data and transaction form.
const transactionCategories = <String>[
  'Food & dining',
  'Groceries',
  'Transport',
  'Bills & utilities',
  'Shopping',
  'Health',
  'Entertainment',
  'Salary',
  'Other',
];

/// A transaction stores a positive amount in paise; [type] determines its sign.
class FinanceTransaction {
  FinanceTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amountInPaise,
    required this.type,
    required this.date,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'A transaction ID is required.');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError.value(
        title,
        'title',
        'A transaction title is required.',
      );
    }
    if (amountInPaise <= 0) {
      throw ArgumentError.value(
        amountInPaise,
        'amountInPaise',
        'The amount must be greater than zero.',
      );
    }
  }

  final String id;
  final String title;
  final String category;
  final int amountInPaise;
  final TransactionType type;
  final DateTime date;

  bool get isIncome => type == TransactionType.income;

  int get signedAmountInPaise => isIncome ? amountInPaise : -amountInPaise;

  FinanceTransaction copyWith({
    String? id,
    String? title,
    String? category,
    int? amountInPaise,
    TransactionType? type,
    DateTime? date,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amountInPaise: amountInPaise ?? this.amountInPaise,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}
