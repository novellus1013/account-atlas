import 'package:account_atlas/core/app/app_shell.dart';
import 'package:account_atlas/features/accounts/presentation/view/account_detail_screen.dart';
import 'package:account_atlas/features/accounts/presentation/view/accounts_screen.dart';
import 'package:account_atlas/features/accounts/presentation/view/add_edit_account_screen.dart';
import 'package:account_atlas/features/cleanup/presentation/clean_up_screen.dart';
import 'package:account_atlas/features/home/presentation/home_screen.dart';
import 'package:account_atlas/features/report/presentation/report_screen.dart';
import 'package:account_atlas/features/services/presentation/add_edit_service_screen.dart';
import 'package:account_atlas/features/services/presentation/service_detail_screen.dart';
import 'package:account_atlas/features/services/presentation/services_screen.dart';
import 'package:account_atlas/features/settings/presentation/settings_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, shell) {
        return AppShell(shell: shell);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => HomeScreen()),
        GoRoute(
          path: '/accounts',
          builder: (context, state) => AccountsScreen(), //accounts의 list
          routes: [
            GoRoute(
              //account table의 id
              path: ':id',
              builder: (context, state) => AccountDetailScreen(
                id: state.pathParameters['id']!,
              ), //특정 accounts에 속한 services list
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => AddEditAccountScreen(),
            ),
            GoRoute(
              //accounts table의 id
              path: ':id/edit',
              builder: (context, state) =>
                  AddEditAccountScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => ServicesScreen(), //services list
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) => ServiceDetailScreen(
                id: state.pathParameters['id']!,
              ), //특정 service의 detail 정보
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => AddEditServiceScreen(),
            ),
            GoRoute(
              //services table의 id
              path: 'edit/:id',
              builder: (context, state) =>
                  AddEditServiceScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(path: '/report', builder: (context, state) => ReportScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
    GoRoute(path: '/cleanup', builder: (context, state) => CleanUpScreen()),
  ],
);
