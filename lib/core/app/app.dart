import 'package:account_atlas/core/router/app_router.dart';
import 'package:account_atlas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter, theme: AppTheme.light);
  }
}
