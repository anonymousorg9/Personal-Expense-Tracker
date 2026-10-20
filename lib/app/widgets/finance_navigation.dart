import 'package:flutter/material.dart';

import '../router.dart';

/// Shared section navigation for narrow and wide layouts.
class FinanceNavigationBar extends StatelessWidget {
  const FinanceNavigationBar({required this.selectedIndex, super.key});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) =>
          _selectDestination(context, index, selectedIndex),
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
    );
  }
}

class FinanceSidebar extends StatelessWidget {
  const FinanceSidebar({required this.selectedIndex, super.key});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const destinations = [
      (icon: Icons.grid_view_rounded, label: 'Dashboard'),
      (icon: Icons.swap_horiz_rounded, label: 'Transactions'),
      (icon: Icons.insights_rounded, label: 'Analytics'),
    ];

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
          for (var index = 0; index < destinations.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                selected: selectedIndex == index,
                selectedTileColor: colorScheme.primary.withValues(alpha: 0.09),
                selectedColor: colorScheme.primary,
                leading: Icon(destinations[index].icon, size: 21),
                title: Text(
                  destinations[index].label,
                  style: TextStyle(
                    fontWeight: selectedIndex == index
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                onTap: () => _selectDestination(context, index, selectedIndex),
              ),
            ),
        ],
      ),
    );
  }
}

void _selectDestination(BuildContext context, int index, int selectedIndex) {
  if (index == selectedIndex) return;
  if (index == 0) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return;
  }

  final route = index == 1 ? AppRouter.transactions : AppRouter.analytics;
  Navigator.of(context)
      .pushNamedAndRemoveUntil(route, (route) => route.isFirst);
}
