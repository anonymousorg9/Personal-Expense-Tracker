import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../app/widgets/finance_navigation.dart';
import 'finance_controller.dart';
import 'finance_transaction.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  static final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );
  static final _dateFormat = DateFormat('EEE, d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final useSidebar = MediaQuery.sizeOf(context).width >= 1100;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (useSidebar) const FinanceSidebar(selectedIndex: 1),
            Expanded(child: _TransactionsContent(useSidebar: useSidebar)),
          ],
        ),
      ),
      bottomNavigationBar: useSidebar
          ? null
          : const FinanceNavigationBar(selectedIndex: 1),
    );
  }

  static void _openForm(
    BuildContext context, [
    FinanceTransaction? transaction,
  ]) {
    Navigator.of(context)
        .pushNamed(AppRouter.transactionForm, arguments: transaction);
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    FinanceTransaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: Text('Remove “${transaction.title}” from your transactions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            key: const Key('confirm-delete-transaction'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    context.read<FinanceController>().delete(transaction.id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Transaction deleted')));
  }
}

class _TransactionsContent extends StatelessWidget {
  const _TransactionsContent({required this.useSidebar});

  final bool useSidebar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(useSidebar ? 36 : 20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          key: Key('transactions-screen-title'),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text('Your income and spending, in one place.'),
                      ],
                    ),
                  ),
                  if (useSidebar)
                    FilledButton.icon(
                      key: const Key('add-transaction'),
                      onPressed: () => TransactionsScreen._openForm(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add transaction'),
                    )
                  else
                    IconButton.filledTonal(
                      key: const Key('add-transaction'),
                      tooltip: 'Add transaction',
                      onPressed: () => TransactionsScreen._openForm(context),
                      icon: const Icon(Icons.add_rounded),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<FinanceController>(
                  builder: (context, controller, _) {
                    final transactions = controller.transactions;
                    if (transactions.isEmpty) {
                      return const _EmptyTransactions();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.isDemoData)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'DEMO DATA · Sample transactions included',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: transactions.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return _TransactionTile(
                                transaction: transaction,
                                amount: TransactionsScreen._currency.format(
                                  transaction.amountInPaise / 100,
                                ),
                                date: TransactionsScreen._dateFormat.format(
                                  transaction.date,
                                ),
                                onEdit: () => TransactionsScreen._openForm(
                                  context,
                                  transaction,
                                ),
                                onDelete: () =>
                                    TransactionsScreen._confirmDelete(
                                      context,
                                      transaction,
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.amount,
    required this.date,
    required this.onEdit,
    required this.onDelete,
  });

  final FinanceTransaction transaction;
  final String amount;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final amountColor = transaction.isIncome
        ? const Color(0xFF15803D)
        : colorScheme.onSurface;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundColor: transaction.isIncome
              ? const Color(0x1A16A34A)
              : colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            transaction.isIncome
                ? Icons.south_west_rounded
                : Icons.north_east_rounded,
            color: transaction.isIncome
                ? const Color(0xFF15803D)
                : colorScheme.primary,
          ),
        ),
        title: Text(
          transaction.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${transaction.category} · $date'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isIncome ? '+' : '−'}$amount',
              style: TextStyle(fontWeight: FontWeight.w700, color: amountColor),
            ),
            PopupMenuButton<String>(
              key: Key('transaction-actions-${transaction.id}'),
              tooltip: 'Transaction actions',
              onSelected: (action) {
                if (action == 'edit') onEdit();
                if (action == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No transactions yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text('Add your first income or expense to get started.'),
        ],
      ),
    );
  }
}
