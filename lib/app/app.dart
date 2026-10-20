import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/exchange_rates/exchange_rate_service.dart';
import '../features/transactions/finance_controller.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key, this.exchangeRateService});

  final ExchangeRateService? exchangeRateService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => FinanceController.withDemoData()),
        if (exchangeRateService == null)
          Provider<ExchangeRateService>(
            create: (_) => ExchangeRateService(),
            dispose: (_, service) => service.close(),
          )
        else
          Provider<ExchangeRateService>.value(value: exchangeRateService!),
      ],
      child: Consumer<ThemeController>(
        builder: (context, controller, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Personal Finance Tracker',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: controller.themeMode,
            initialRoute: AppRouter.dashboard,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
