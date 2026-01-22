import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';
import 'package:account_atlas/features/accounts/presentation/widget/icon_box.dart';
import 'package:account_atlas/features/shared/account_icon_config.dart';
import 'package:account_atlas/features/accounts/presentation/state/accounts_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountsViewModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.grey50,
        appBar: AppBar(
          title: Text('My Accounts'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColor.primary),
              onPressed: () => context.push('/accounts/add'),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.basic),
          child: _buildBody(state),
        ),
      ),
    );
  }
}

Widget _buildBody(AccountsState state) {
  return switch (state) {
    AccountsLoading() => const Center(child: CircularProgressIndicator()),
    AccountsEmpty() => const Center(child: Text('No accounts found.')),
    AccountsError(message: final message) => Center(child: Text(message)),
    AccountsLoaded(accounts: final accounts) => ListView.separated(
      itemCount: accounts.length,
      separatorBuilder: (context, index) => Gaps.v16,
      itemBuilder: (context, index) {
        final account = accounts[index];

        return _AccountListItem(
          accountId: account.accountId,
          identifier: account.identifier,
          provider: account.provider,
          totalServices: account.totalServices,
          bill: account.monthlyBill,
          currency: account.currency,
        );
      },
    ),
  };
}

class _AccountListItem extends StatelessWidget {
  final int accountId;
  final String identifier;
  final AccountProvider provider;
  final int totalServices;
  final int bill;
  final Currency currency;

  const _AccountListItem({
    required this.identifier,
    required this.provider,
    required this.totalServices,
    required this.bill,
    required this.currency,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    final currencyMark = currency == Currency.en ? '\$' : "₩";

    void onMoveDetail(int id) {
      context.push('/accounts/$id/detail');
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onMoveDetail(accountId),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.basic,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: [
              BoxShadow(
                blurRadius: AppSpacing.sm,
                offset: Offset(0, AppSpacing.xs),
                color: AppColor.black.withValues(alpha: 0.05),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconBox(
                    color: accountIconMap[provider]!.bg,
                    icon: accountIconMap[provider]!.icon,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identifier,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        Gaps.v8,
                        Text(
                          provider.dbCode,
                          style: TextStyle(
                            fontSize: AppTextSizes.sm,
                            color: accountIconMap[provider]!.bg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              Gaps.v24,
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.basic,
                ),
                decoration: BoxDecoration(
                  color: AppColor.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalServices services',
                      style: const TextStyle(
                        color: AppColor.textGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$currencyMark${bill.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / mo',
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
