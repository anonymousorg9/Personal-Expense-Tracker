import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'finance_controller.dart';
import 'finance_transaction.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({this.transaction, super.key});

  final FinanceTransaction? transaction;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late TransactionType _type;
  late String _category;
  late DateTime _date;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    _titleController = TextEditingController(text: transaction?.title ?? '');
    _amountController = TextEditingController(
      text: transaction == null
          ? ''
          : (transaction.amountInPaise / 100).toStringAsFixed(2),
    );
    _type = transaction?.type ?? TransactionType.expense;
    _category = transaction?.category ?? transactionCategories.first;
    _date = transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit transaction' : 'New transaction'),
        leading: IconButton(
          tooltip: 'Cancel',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Text(
                    _isEditing
                        ? 'Update the details below.'
                        : 'Record income or spending.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<TransactionType>(
                    key: const Key('transaction-type'),
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        icon: Icon(Icons.north_east_rounded),
                        label: Text('Expense'),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        icon: Icon(Icons.south_west_rounded),
                        label: Text('Income'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      setState(() => _type = selection.first);
                      if (_category == 'Salary' &&
                          _type == TransactionType.expense) {
                        setState(() => _category = transactionCategories.first);
                      } else if (_type == TransactionType.income &&
                          _category == transactionCategories.first) {
                        setState(() => _category = 'Salary');
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    key: const Key('transaction-title'),
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    maxLength: 64,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'e.g. Monthly groceries',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a description.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('transaction-amount'),
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.00',
                      prefixText: '\u20B9 ',
                    ),
                    validator: _validateAmount,
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    key: const Key('transaction-category'),
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: transactionCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    key: const Key('transaction-date'),
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(DateFormat('d MMM yyyy').format(_date)),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    key: const Key('save-transaction'),
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(
                      _isEditing ? 'Save changes' : 'Save transaction',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateAmount(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter an amount.';
    if (!RegExp(r'^\d{1,12}(\.\d{1,2})?$').hasMatch(input)) {
      return 'Use up to 12 digits and 2 decimal places.';
    }
    final amount = double.tryParse(input);
    if (amount == null || !amount.isFinite) return 'Enter a valid amount.';
    if (amount <= 0) return 'Amount must be greater than zero.';
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<FinanceController>();
    final amountInPaise = _amountToPaise(_amountController.text.trim());
    final transaction = FinanceTransaction(
      id:
          widget.transaction?.id ??
          'txn-${DateTime.now().microsecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _category,
      amountInPaise: amountInPaise,
      type: _type,
      date: _date,
    );

    if (_isEditing) {
      if (!controller.update(transaction)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This transaction no longer exists.')),
        );
        Navigator.of(context).pop();
        return;
      }
    } else {
      controller.add(transaction);
    }

    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop(true);
    messenger.showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Transaction updated' : 'Transaction added'),
      ),
    );
  }

  int _amountToPaise(String value) {
    final parts = value.split('.');
    final wholeRupees = int.parse(parts.first);
    final paise = parts.length == 1
        ? 0
        : int.parse(parts.last.padRight(2, '0'));
    return wholeRupees * 100 + paise;
  }
}
