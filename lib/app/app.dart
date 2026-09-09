import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/dashboard/dashboard_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, controller, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Personal Finance Tracker',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: controller.themeMode,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
