# Personal Finance Tracker

A Flutter personal finance tracker for recording income and expenses, viewing calculated balances, and reviewing spending activity. The project uses a feature-first structure and is being developed in small, verified milestones.

## Current Features

- Responsive dashboard with net balance, income and expense totals, a seven-day spending chart, recent transactions, and the largest recorded expense category.
- Transaction management with add, edit, delete, category, date, type, and amount validation.
- Analytics screen and light, dark, and system theme modes.
- INR formatting and sample data clearly labeled in the dashboard.

Transactions currently live in memory. The sample transactions are for demonstration and reset when the app is restarted; persistent storage and live financial data are not implemented.

## Dashboard Evidence

The screenshots show the running Flutter web dashboard at mobile and desktop widths. The implementation and state logic are available in [dashboard_screen.dart](lib/features/dashboard/dashboard_screen.dart), [finance_controller.dart](lib/features/transactions/finance_controller.dart), and [finance_transaction.dart](lib/features/transactions/finance_transaction.dart).

![Personal finance dashboard at mobile width](docs/screenshots/dashboard-mobile.png)

*Mobile dashboard, 360 × 695 capture.*

![Personal finance dashboard at desktop width](docs/screenshots/dashboard-desktop.png)

*Desktop dashboard, 1242 × 761 capture.*

The transaction list is shown at desktop width:

![Transactions screen at desktop width](docs/screenshots/transactions-desktop.png)

*Transactions screen, 1150 × 765 capture.*

### Source Evidence

The dashboard derives its displayed totals and chart data from the shared transaction controller:

```dart
final recentTransactions = finance.transactions.take(4).toList();
final dailySpending = _dailySpendingForLastWeek(finance);
final categoryTotals = finance.expenseTotalsByCategory.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));
```

See the [dashboard implementation](lib/features/dashboard/dashboard_screen.dart) and [transaction controller](lib/features/transactions/finance_controller.dart) for the complete code.

## Verification

At the dashboard milestone, the project was checked with Flutter static analysis and widget tests:

```powershell
flutter analyze
flutter test
```

Recorded results: `No issues found!` and `All tests passed!` (10 tests).

## Run Locally

Install the Flutter SDK, then run these commands from the project directory:

```powershell
flutter pub get
flutter run -d chrome
```

To use Flutter's web server instead, run `flutter run -d web-server` and open the localhost URL it prints.

## Project Structure

```text
lib/
├── app/                 # App setup, routes, and theme
├── features/
│   ├── analytics/       # Analytics screen
│   ├── dashboard/       # Dashboard and spending chart
│   └── transactions/    # Transaction model, state, and screens
└── main.dart

test/                    # Widget and controller tests
docs/screenshots/        # Runtime evidence
```

## Current Limitations

- Transaction state is in memory and is lost when the app restarts.
- The dashboard sample data is illustrative and is not linked to a bank or external API.
- Budgets, persistent storage, and production deployment are future work.
