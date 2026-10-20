import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/theme_controller.dart';
import '../transactions/finance_controller.dart';
import '../transactions/finance_transaction.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final useSidebar = screenWidth >= 1100;
    final finance = context.watch<FinanceController>();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (useSidebar)
              _SideNavigation(
                selectedIndex: _selectedIndex,
                onSelected: _onNavigationSelected,
              ),
            Expanded(
              child: _DashboardContent(currency: _currency, finance: finance),
            ),
          ],
        ),
      ),
      bottomNavigationBar: useSidebar
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onNavigationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.swap_horiz_outlined),
                  selectedIcon: Icon(Icons.swap_horiz_rounded),
                  label: 'Transactions',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights_rounded),
                  label: 'Analytics',
                ),
              ],
            ),
    );
  }

  Future<void> _onNavigationSelected(int index) async {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (index == 0) return;

    final route = index == 1 ? AppRouter.transactions : AppRouter.analytics;
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (route) => route.isFirst);
    if (!mounted) return;
    setState(() => _selectedIndex = 0);
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 248,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.dividerColor.withValues(alpha: 0.45)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'FinTrack',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _NavItem(
            icon: Icons.swap_horiz_rounded,
            label: 'Transactions',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _NavItem(
            icon: Icons.insights_rounded,
            label: 'Analytics',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          selected: selected,
          selectedTileColor: colorScheme.primary.withValues(alpha: 0.09),
          selectedColor: colorScheme.primary,
          leading: Icon(icon, size: 21),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.currency, required this.finance});

  final NumberFormat currency;
  final FinanceController finance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentPadding = screenWidth >= 1100 ? 34.0 : 20.0;
    final recentTransactions = finance.transactions.take(4).toList();
    final dailySpending = _dailySpendingForLastWeek(finance);
    final categoryTotals = finance.expenseTotalsByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = categoryTotals.isEmpty ? null : categoryTotals.first;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(contentPadding, 24, contentPadding, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _DashboardHeader(),
              if (finance.isDemoData) ...[
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: _DemoDataBadge()),
              ],
              const SizedBox(height: 22),
              _BalanceCard(
                currency: currency,
                balanceInPaise: finance.balanceInPaise,
              ),
              const SizedBox(height: 18),
              _SummaryCards(
                currency: currency,
                incomeInPaise: finance.incomeTotalInPaise,
                expenseInPaise: finance.expenseTotalInPaise,
                balanceInPaise: finance.balanceInPaise,
              ),
              const SizedBox(height: 28),
              _SpendingInsight(
                currency: currency,
                totalExpenseInPaise: finance.expenseTotalInPaise,
                topCategory: topCategory,
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 850;

                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                title: 'Spending overview',
                                trailing: 'Last 7 days',
                              ),
                              const SizedBox(height: 14),
                              _SpendingChart(
                                currency: currency,
                                dailySpending: dailySpending,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                title: 'Recent transactions',
                                trailing: 'View all',
                                onPressed: () =>
                                    Navigator.of(context)
                                        .pushNamed(AppRouter.transactions),
                              ),
                              const SizedBox(height: 14),
                              _RecentTransactions(
                                currency: currency,
                                transactions: recentTransactions,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _SectionHeader(
                        title: 'Spending overview',
                        trailing: 'Last 7 days',
                      ),
                      const SizedBox(height: 14),
                      _SpendingChart(
                        currency: currency,
                        dailySpending: dailySpending,
                      ),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: 'Recent transactions',
                        trailing: 'View all',
                        onPressed: () =>
                            Navigator.of(context)
                                .pushNamed(AppRouter.transactions),
                      ),
                      const SizedBox(height: 14),
                      _RecentTransactions(
                        currency: currency,
                        transactions: recentTransactions,
                      ),
                    ],
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

List<_DailySpend> _dailySpendingForLastWeek(FinanceController finance) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final firstDay = today.subtract(const Duration(days: 6));
  final totals = List<int>.filled(7, 0);

  for (final transaction in finance.transactions) {
    if (transaction.isIncome) continue;
    final transactionDay = DateTime(
      transaction.date.year,
      transaction.date.month,
      transaction.date.day,
    );
    final index = transactionDay.difference(firstDay).inDays;
    if (index >= 0 && index < totals.length) {
      totals[index] += transaction.amountInPaise;
    }
  }

  return List.generate(
    totals.length,
    (index) => _DailySpend(
      date: firstDay.add(Duration(days: index)),
      amountInPaise: totals[index],
    ),
  );
}

class _DailySpend {
  const _DailySpend({required this.date, required this.amountInPaise});

  final DateTime date;
  final int amountInPaise;
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compact = MediaQuery.sizeOf(context).width < 520;
    final themeController = context.read<ThemeController>();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FINTRACK · PERSONAL FINANCE',
                style: TextStyle(
                  fontSize: compact ? 10 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your financial overview',
                style: TextStyle(
                  fontSize: compact ? 20 : 25,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Add transaction',
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRouter.transactionForm),
          icon: const Icon(Icons.add_rounded),
        ),
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: themeController.toggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.currency, required this.balanceInPaise});

  final NumberFormat currency;
  final int balanceInPaise;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              isDark ? AppColors.primaryDark : const Color(0xFF3B82F6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.22),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -36,
              top: -72,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 90,
              bottom: -112,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.055),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 18,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Net balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        key: const Key('dashboard-balance-switcher'),
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          );
                          return FadeTransition(
                            opacity: curvedAnimation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.12),
                                end: Offset.zero,
                              ).animate(curvedAnimation),
                              child: child,
                            ),
                          );
                        },
                        layoutBuilder: (currentChild, previousChildren) =>
                            Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [...previousChildren, ?currentChild],
                            ),
                        child: KeyedSubtree(
                          key: ValueKey(balanceInPaise),
                          child: Text(
                            currency.format(balanceInPaise / 100),
                            key: const Key('dashboard-balance-value'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Calculated from recorded income and expenses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            balanceInPaise > 0
                                ? Icons.trending_up_rounded
                                : balanceInPaise < 0
                                ? Icons.trending_down_rounded
                                : Icons.remove_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            balanceInPaise > 0
                                ? 'Net positive'
                                : balanceInPaise < 0
                                ? 'Net negative'
                                : 'Balanced',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoDataBadge extends StatelessWidget {
  const _DemoDataBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          'DEMO DATA · Figures include sample transactions',
          style: TextStyle(
            color: colors.onSecondaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({
    required this.currency,
    required this.incomeInPaise,
    required this.expenseInPaise,
    required this.balanceInPaise,
  });

  final NumberFormat currency;
  final int incomeInPaise;
  final int expenseInPaise;
  final int balanceInPaise;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryData(
        label: 'Income',
        value: currency.format(incomeInPaise / 100),
        icon: Icons.south_west_rounded,
        color: AppColors.income,
        caption: 'Recorded income',
      ),
      _SummaryData(
        label: 'Expenses',
        value: currency.format(expenseInPaise / 100),
        icon: Icons.north_east_rounded,
        color: AppColors.expense,
        caption: 'Recorded spending',
      ),
      _SummaryData(
        label: 'Net result',
        value: currency.format(balanceInPaise / 100),
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.primary,
        caption: 'Income minus expenses',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 900 => 3,
          >= 560 => 2,
          _ => 1,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 128,
          ),
          itemBuilder: (context, index) {
            final item = cards[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.value,
                            key: Key(
                              'summary-value-${item.label.toLowerCase().replaceAll(' ', '-')}',
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.caption,
                            style: TextStyle(
                              color: item.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SpendingInsight extends StatelessWidget {
  const _SpendingInsight({
    required this.currency,
    required this.totalExpenseInPaise,
    required this.topCategory,
  });

  final NumberFormat currency;
  final int totalExpenseInPaise;
  final MapEntry<String, int>? topCategory;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final entry = topCategory;
    final message = entry == null || totalExpenseInPaise == 0
        ? 'Add an expense to see where most of your recorded spending goes.'
        : '${entry.key} is the largest recorded spending category at '
              '${currency.format(entry.value / 100)} '
              '(${(entry.value / totalExpenseInPaise * 100).round()}% of expenses).';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.tertiary.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_outlined, color: colors.tertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spending insight',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  const _SpendingChart({required this.currency, required this.dailySpending});

  final NumberFormat currency;
  final List<_DailySpend> dailySpending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisCurrency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final maxAmount = dailySpending.fold<int>(
      0,
      (maximum, day) =>
          day.amountInPaise > maximum ? day.amountInPaise : maximum,
    );
    final maxY = maxAmount == 0 ? 1000.0 : maxAmount / 100 * 1.2;
    final interval = maxY / 5;
    final spots = [
      for (var index = 0; index < dailySpending.length; index++)
        FlSpot(index.toDouble(), dailySpending[index].amountInPaise / 100),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (maxAmount == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'No expenses recorded in the last 7 days.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            SizedBox(
              height: 242,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.dividerColor.withValues(alpha: 0.35),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 6,
                            child: Text(
                              axisCurrency.format(value),
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              maxLines: 1,
                              softWrap: false,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        minIncluded: true,
                        maxIncluded: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          final index = value.round();

                          if (index < 0 || index >= dailySpending.length) {
                            return const SizedBox.shrink();
                          }

                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              DateFormat('E').format(dailySpending[index].date),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          theme.colorScheme.inverseSurface,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            currency.format(spot.y),
                            TextStyle(
                              color: theme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      color: theme.colorScheme.primary,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: index == spots.length - 1 ? 4 : 3,
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({
    required this.currency,
    required this.transactions,
  });

  final NumberFormat currency;
  final List<FinanceTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: transactions.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No transactions recorded yet.'),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, _) {
                return Divider(
                  height: 1,
                  indent: 74,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                );
              },
              itemBuilder: (context, index) {
                final transaction = transactions[index];

                final amountColor = transaction.isIncome
                    ? AppColors.income
                    : Theme.of(context).colorScheme.onSurface;

                final iconColor = transaction.isIncome
                    ? AppColors.income
                    : Theme.of(context).colorScheme.primary;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      _transactionIcon(transaction),
                      size: 20,
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      '${transaction.category} · '
                      '${DateFormat('d MMM').format(transaction.date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Text(
                    '${transaction.isIncome ? '+' : '−'}'
                    '${currency.format(transaction.amountInPaise / 100)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

IconData _transactionIcon(FinanceTransaction transaction) {
  if (transaction.isIncome) return Icons.south_west_rounded;
  return switch (transaction.category) {
    'Food & dining' => Icons.local_cafe_outlined,
    'Groceries' => Icons.shopping_basket_outlined,
    'Transport' => Icons.directions_car_outlined,
    'Bills & utilities' => Icons.bolt_outlined,
    'Shopping' => Icons.shopping_bag_outlined,
    'Health' => Icons.health_and_safety_outlined,
    'Entertainment' => Icons.movie_outlined,
    _ => Icons.receipt_long_outlined,
  };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.trailing,
    this.onPressed,
  });

  final String title;
  final String trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        if (onPressed == null)
          Text(trailing, style: Theme.of(context).textTheme.bodySmall)
        else
          TextButton(onPressed: onPressed, child: Text(trailing)),
      ],
    );
  }
}

class _SummaryData {
  const _SummaryData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.caption,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String caption;
}
