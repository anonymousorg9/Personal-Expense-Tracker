import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/theme_controller.dart';

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
    decimalDigits: 0,
  );

  final List<_TransactionData> _transactions = const [
    _TransactionData(
      title: 'Salary',
      subtitle: 'Primary income',
      amount: 45000,
      icon: Icons.account_balance_wallet_outlined,
      isIncome: true,
    ),
    _TransactionData(
      title: 'Groceries',
      subtitle: 'Food & essentials',
      amount: 2450,
      icon: Icons.shopping_basket_outlined,
    ),
    _TransactionData(
      title: 'Electricity',
      subtitle: 'Bills & utilities',
      amount: 1850,
      icon: Icons.bolt_outlined,
    ),
    _TransactionData(
      title: 'Coffee',
      subtitle: 'Food & dining',
      amount: 420,
      icon: Icons.local_cafe_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final useSidebar = screenWidth >= 1100;

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
              child: _DashboardContent(
                currency: _currency,
                transactions: _transactions,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: useSidebar
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex >= 4 ? 0 : _selectedIndex,
              onDestinationSelected: _onNavigationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.swap_horiz_outlined),
                  selectedIcon: Icon(Icons.swap_horiz_rounded),
                  label: 'Transactions',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart_rounded),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }

  void _onNavigationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            icon: Icons.account_balance_wallet_outlined,
            label: 'Budgets',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _NavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Reports',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
          _NavItem(
            icon: Icons.category_outlined,
            label: 'Categories',
            selected: selectedIndex == 4,
            onTap: () => onSelected(4),
          ),
          const Spacer(),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
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
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.currency, required this.transactions});

  final NumberFormat currency;
  final List<_TransactionData> transactions;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentPadding = screenWidth >= 1100 ? 34.0 : 20.0;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(contentPadding, 24, contentPadding, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _DashboardHeader(),
              const SizedBox(height: 26),
              const _BalanceCard(),
              const SizedBox(height: 18),
              _SummaryCards(currency: currency),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 1050;

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
                                trailing: 'This month',
                                onPressed: () {},
                              ),
                              const SizedBox(height: 14),
                              const _SpendingChart(),
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
                                onPressed: () {},
                              ),
                              const SizedBox(height: 14),
                              _RecentTransactions(
                                currency: currency,
                                transactions: transactions,
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
                        trailing: 'This month',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 14),
                      const _SpendingChart(),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: 'Recent transactions',
                        trailing: 'View all',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 14),
                      _RecentTransactions(
                        currency: currency,
                        transactions: transactions,
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.read<ThemeController>();

    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Adithya',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'Your financial overview',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: controller.toggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
        const SizedBox(width: 4),
        CircleAvatar(
          radius: 21,
          child: Text(
            'AS',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 18,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\u20B984,250',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '+12.8% from last month',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x24FFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Healthy',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryData(
        label: 'Income',
        value: currency.format(45000),
        icon: Icons.arrow_downward_rounded,
        color: AppColors.income,
        caption: '+8.4%',
      ),
      _SummaryData(
        label: 'Expenses',
        value: currency.format(27450),
        icon: Icons.arrow_upward_rounded,
        color: AppColors.expense,
        caption: '-3.1%',
      ),
      _SummaryData(
        label: 'Savings',
        value: currency.format(17550),
        icon: Icons.savings_outlined,
        color: AppColors.primary,
        caption: '41.8% rate',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 750;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: wide ? 3 : 1,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 118,
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

class _SpendingChart extends StatelessWidget {
  const _SpendingChart();

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<FlSpot> _spots = [
    FlSpot(0, 1800),
    FlSpot(1, 2700),
    FlSpot(2, 2000),
    FlSpot(3, 3400),
    FlSpot(4, 2700),
    FlSpot(5, 4200),
    FlSpot(6, 3100),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
        child: SizedBox(
          height: 270,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 5000,
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: 1000,
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
                    interval: 1000,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          currency.format(value),
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.textTheme.bodySmall?.color,
                          ),
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

                      if (index < 0 || index >= _days.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          _days[index],
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
                  spots: _spots,
                  isCurved: true,
                  barWidth: 3,
                  color: theme.colorScheme.primary,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: index == _spots.length - 1 ? 4 : 3,
                        color: theme.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: theme.colorScheme.surface,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
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
  final List<_TransactionData> transactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
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
              child: Icon(transaction.icon, size: 20, color: iconColor),
            ),
            title: Text(
              transaction.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(transaction.subtitle),
            ),
            trailing: Text(
              '${transaction.isIncome ? '+' : '-'}${currency.format(transaction.amount)}',
              style: TextStyle(fontWeight: FontWeight.w700, color: amountColor),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.trailing,
    required this.onPressed,
  });

  final String title;
  final String trailing;
  final VoidCallback onPressed;

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

class _TransactionData {
  const _TransactionData({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    this.isIncome = false,
  });

  final String title;
  final String subtitle;
  final int amount;
  final IconData icon;
  final bool isIncome;
}