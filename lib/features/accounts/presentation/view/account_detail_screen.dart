import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/ui_helpers.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/account_detail_view_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/shared/account_icon_config.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountDetailScreen extends ConsumerWidget {
  final int accountId;
  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountDetailViewModelProvider(accountId));
    final catalogState = ref.watch(serviceCatalogProvider);

    ref.listen(accountDetailViewModelProvider(accountId), (previous, next) {
      if (next is AccountDetailDeleted && context.mounted) {
        context.pop();
      }
    });

    Future<void> confirmDelete(BuildContext context) async {
      final title = 'Delete account';
      final main = 'This will remove the account and all services tied to it.';
      final btn = 'Delete';
      final confirm = await showWarningPopDialog(context, title, main, btn);

      if (confirm != true) {
        return;
      }

      await ref
          .read(accountDetailViewModelProvider(accountId).notifier)
          .delete();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColor.primary),
              onPressed: () => context.push('/accounts/$accountId/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColor.error),
              onPressed: () => confirmDelete(context),
            ),
          ],
        ),
        body: _buildBody(
          accountState: accountState,
          catalogState: catalogState,
        ),
      ),
    );
  }
}

Widget _buildBody({
  required AccountDetailState accountState,
  required AsyncValue<Map<String, ServiceCatalogItem>> catalogState,
}) {
  return switch (accountState) {
    AccountDetailLoading() => const Center(child: CircularProgressIndicator()),
    AccountDetailError(message: final message) => Center(child: Text(message)),
    AccountDetailDeleted() => const Center(child: Text('Account deleted.')),
    AccountDetailLoaded(account: final account) => catalogState.when(
      data: (catalog) =>
          _AccountDetailContent(account: account, catalog: catalog),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    ),
  };
}

class _AccountDetailContent extends StatelessWidget {
  final AccountDetailReadModel account;
  final Map<String, ServiceCatalogItem> catalog;

  const _AccountDetailContent({required this.account, required this.catalog});

  @override
  Widget build(BuildContext context) {
    final config = accountIconMap[account.account.provider];
    final summaryText = priceTextFormatter(
      account.monthlyBillByCurrency,
      Currency.en,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: config?.bg ?? AppColor.primary,
              borderRadius: BorderRadius.circular(AppSpacing.xl),
            ),
            child: Column(
              children: [
                Icon(
                  config?.icon ?? Icons.account_circle,
                  color: Colors.white,
                  size: 40,
                ),
                Gaps.v16,
                Text(
                  account.account.identifier,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v24,
                const Divider(color: Colors.white24),
                Gaps.v16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(label: 'Monthly Bill', value: summaryText!),
                    _SummaryItem(
                      label: 'Provider',
                      value: account.account.provider.dbCode,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gaps.v32,
          _SectionHeader(
            title: 'Subscription Services',
            count: account.paidServices.length,
          ),
          Gaps.v12,
          ...account.paidServices.map(
            (s) => _ServiceTile(service: s, catalog: catalog),
          ),
          Gaps.v32,
          _SectionHeader(
            title: 'Free Services',
            count: account.freeServices.length,
          ),
          Gaps.v12,
          ...account.freeServices.map(
            (s) => _ServiceTile(service: s, catalog: catalog),
          ),
          Gaps.v32,
          Gaps.v8,
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColor.backgroundGrey,
            fontSize: AppSpacing.md,
          ),
        ),
        Gaps.v4,
        Text(
          value,
          style: const TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: AppSpacing.basic,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppSpacing.basic,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Text(
            '$count items',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceDetailReadModel service;
  final Map<String, ServiceCatalogItem> catalog;

  const _ServiceTile({required this.service, required this.catalog});

  @override
  Widget build(BuildContext context) {
    final iconConfig = _resolveServiceIcon(service, catalog);

    String? billingText = '';
    String? priceText = '';

    if (service.isPay && service.nextBillingDate != null) {
      billingText = billingTextFormatter(service.nextBillingDate!);
    } else {
      billingText = null;
    }

    if (service.isPay && service.amount != null && service.currency != null) {
      priceText = priceTextFormatter(service.amount!, service.currency!);
    } else {
      priceText = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: AppSpacing.xl + AppSpacing.lg,
              height: AppSpacing.xl + AppSpacing.lg,
              decoration: BoxDecoration(
                color: iconConfig.backgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.basic),
              ),
              child: Center(child: iconConfig.icon),
            ),
            Gaps.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSpacing.basic,
                    ),
                  ),
                  if (billingText != null)
                    Text(
                      billingText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: AppTextSizes.sm,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              priceText ?? 'none',
              style: const TextStyle(
                color: AppColor.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.h8,
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ServiceIconConfig {
  final Widget icon;
  final Color backgroundColor;

  const _ServiceIconConfig({required this.icon, required this.backgroundColor});
}

_ServiceIconConfig _resolveServiceIcon(
  ServiceDetailReadModel service,
  Map<String, ServiceCatalogItem> catalog,
) {
  final categoryKey = service.service.category.name;
  final catalogItem = catalog[service.iconKey];
  final iconKey = catalogItem?.iconKey;
  final iconColor = catalogItem?.iconColor;

  if (iconKey != null) {
    return _ServiceIconConfig(
      icon: SizedBox(
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        child: Image.asset('assets/logos/$iconKey.png', color: AppColor.white),
      ),
      backgroundColor: iconColor != null ? Color(iconColor) : AppColor.black,
    );
  }

  return _ServiceIconConfig(
    icon:
        serviceCategoryIcon[categoryKey] ??
        const Icon(Icons.category, color: AppColor.white),
    backgroundColor: AppColor.black,
  );
}
