import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget shell;

  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: shell, bottomNavigationBar: _BottomNav());
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    int getIndexFromLocation(String location) {
      if (location.startsWith('/accounts')) {
        return 1;
      } else if (location.startsWith('/services')) {
        return 2;
      } else if (location.startsWith('/settings')) {
        return 3;
      } else if (location.startsWith('/report')) {
        return 4;
      }
      return 0;
    }

    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = getIndexFromLocation(location);

    return SizedBox(
      height: 100.0,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: AppTextSizes.sm,
        unselectedFontSize: AppTextSizes.sm,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        unselectedItemColor: AppColor.textGrey,
        selectedItemColor: AppColor.primary,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/accounts');
              break;
            case 2:
              context.go('/services');
              break;
            case 3:
              context.go('/settings');
              break;
            case 4:
              context.go('/report');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '계정',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '서비스'),

          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.bar_chart_rounded),
          //   label: '보고서',
          // ),
        ],
      ),
    );
  }
}
