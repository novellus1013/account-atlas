import 'package:account_atlas/core/app/app_shell.dart';
import 'package:account_atlas/features/accounts/presentation/view/account_detail_screen.dart';
import 'package:account_atlas/features/accounts/presentation/view/accounts_screen.dart';
import 'package:account_atlas/features/accounts/presentation/view/add_edit_account_screen.dart';
import 'package:account_atlas/features/cleanup/presentation/clean_up_screen.dart';
import 'package:account_atlas/features/home/presentation/view/home_screen.dart';
import 'package:account_atlas/features/services/presentation/view/add_edit_catalog_screen.dart';
import 'package:account_atlas/features/services/presentation/view/add_edit_service_screen.dart';
import 'package:account_atlas/features/services/presentation/view/service_detail_screen.dart';
import 'package:account_atlas/features/services/presentation/view/services_screen.dart';
import 'package:account_atlas/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
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
              path: ':id/detail',
              builder: (context, state) => AccountDetailScreen(
                accountId: int.parse(state.pathParameters['id']!),
              ), //특정 accounts에 속한 services list
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) =>
                  AddEditAccountScreen(key: UniqueKey()),
            ),
            GoRoute(
              //accounts table의 id
              path: ':id/edit',
              builder: (context, state) => AddEditAccountScreen(
                key: UniqueKey(),
                id: state.pathParameters['id']!,
              ),
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
              routes: [
                // Edit flow: service_detail → catalog → service form
                GoRoute(
                  path: 'edit/catalog',
                  builder: (context, state) => AddEditCatalogScreen(
                    accountId: int.parse(
                      state.uri.queryParameters['accountId']!,
                    ),
                    serviceId: int.parse(state.pathParameters['id']!),
                  ),
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return AddEditServiceScreen(
                      serviceId: int.parse(state.pathParameters['id']!),
                      accountId: extra?['accountId'] as int?,
                      catalogItem: extra?['catalogItem'],
                    );
                  },
                ),
              ],
            ),
            // Add flow: services_screen → catalog → service form → new service detail
            GoRoute(
              path: 'add/catalog',
              builder: (context, state) {
                final accountIdParam = state.uri.queryParameters['accountId'];
                return AddEditCatalogScreen(
                  accountId: accountIdParam != null
                      ? int.parse(accountIdParam)
                      : null,
                );
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return AddEditServiceScreen(
                  accountId: extra?['accountId'] as int?,
                  catalogItem: extra?['catalogItem'],
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
    GoRoute(path: '/cleanup', builder: (context, state) => CleanUpScreen()),
  ],
);
