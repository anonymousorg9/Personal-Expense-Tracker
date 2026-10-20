import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/widgets/finance_navigation.dart';
import '../transactions/finance_controller.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    final useSidebar = MediaQuery.sizeOf(context).width >= 1100;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (useSidebar) const FinanceSidebar(selectedIndex: 2),
            Expanded(child: _AnalyticsContent(useSidebar: useSidebar)),
          ],
        ),
      ),
      bottomNavigationBar: useSidebar
          ? null
          : const FinanceNavigationBar(selectedIndex: 2),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({required this.useSidebar});

  final bool useSidebar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(useSidebar ? 36 : 20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Consumer<FinanceController>(
            builder: (context, controller, _) {
              final categories =
                  controller.expenseTotalsByCategory.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
              final total = controller.expenseTotalInPaise;
              final topCategory = categories.isEmpty ? null : categories.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics',
                    key: Key('analytics-screen-title'),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.isDemoData
                        ? 'Includes sample transactions and changes made in this session.'
                        : 'A breakdown of your recorded spending.',
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total expenses',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AnalyticsScreen._currency.format(total / 100),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.pie_chart_outline_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 36,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Spending by category',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: categories.isEmpty
                        ? const _EmptyAnalytics()
                        : ListView.separated(
                            itemCount: categories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final entry = categories[index];
                              final share = total == 0
                                  ? 0.0
                                  : entry.value / total;
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              entry.key,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            AnalyticsScreen._currency.format(
                                              entry.value / 100,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: share,
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${(share * 100).round()}% of expenses',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (topCategory != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Largest category: ${topCategory.key} · '
                          '${AnalyticsScreen._currency.format(topCategory.value / 100)}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyAnalytics extends StatelessWidget {
  const _EmptyAnalytics();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insights_outlined,
            size: 46,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No spending to analyze yet',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text('Add expenses to see a category breakdown.'),
        ],
      ),
    );
  }
}
