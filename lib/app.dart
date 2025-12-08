import 'package:account_atlas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.light, home: _TestHome());
  }
}

class _TestHome extends StatelessWidget {
  const _TestHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('여기는 시작점')));
  }
}
