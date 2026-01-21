import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/ui_helpers.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/account_detail_view_model.dart';
import 'package:account_atlas/features/home/presentation/vm/home_view_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/shared/account_icon_config.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:account_atlas/features/shared/widgets/action_buttons_bar.dart';
import 'package:account_atlas/features/shared/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountDetailScreen extends ConsumerStatefulWidget {
  final int accountId;
  const AccountDetailScreen({super.key, required this.accountId});

  @override
  ConsumerState<AccountDetailScreen> createState() =>
      _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> {
  int get _accountId => widget.accountId;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showWarningPopDialog(
      context,
      'Delete account',
      'This will remove the account and all services tied to it.',
      'Delete',
    );

    if (confirm != true || !context.mounted) return;

    await ref
        .read(accountDetailViewModelProvider(_accountId).notifier)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountDetailViewModelProvider(_accountId));
    final catalogState = ref.watch(serviceCatalogProvider);

    ref.listen(accountDetailViewModelProvider(_accountId), (previous, next) {
      if (next is AccountDetailDeleted && context.mounted) {
        ref.invalidate(homeViewModelProvider);
        context.pop();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.grey50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _buildBody(
          accountState: accountState,
          catalogState: catalogState,
        ),
      ),
    );
  }

  Widget _buildBody({
    required AccountDetailState accountState,
    required AsyncValue<Map<String, ServiceCatalogItem>> catalogState,
  }) {
    return switch (accountState) {
      AccountDetailLoading() => const LoadingStateWidget(),
      AccountDetailError(message: final message) => ErrorStateWidget(
        title: 'Error loading account',
        message: message,
        onRetry: () =>
            ref.invalidate(accountDetailViewModelProvider(_accountId)),
      ),
      AccountDetailDeleted() => const Center(child: Text('Account deleted.')),
      AccountDetailLoaded(account: final account) => catalogState.when(
        data: (catalog) => _buildContent(account, catalog),
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          title: 'Error loading catalog',
          message: error.toString(),
        ),
      ),
    };
  }

  Widget _buildContent(
    AccountDetailReadModel account,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    return Column(
      children: [
        Expanded(
          child: _AccountDetailContent(account: account, catalog: catalog),
        ),
        ActionButtonsBar(
          onEdit: () => context.push('/accounts/$_accountId/edit'),
          onDelete: () => _confirmDelete(context),
        ),
      ],
    );
  }
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Header Card
          _AccountHeaderCard(
            identifier: account.account.identifier,
            provider: account.account.provider.dbCode,
            monthlyBill: summaryText ?? '\$0',
            iconConfig: config,
          ),
          Gaps.v32,

          // Subscription Services Section
          _SectionHeader(
            title: 'Subscription Services',
            count: account.paidServices.length,
          ),
          Gaps.v12,
          ...account.paidServices.map(
            (s) => _ServiceTile(service: s, catalog: catalog),
          ),
          Gaps.v32,

          // Free Services Section
          _SectionHeader(
            title: 'Free Services',
            count: account.freeServices.length,
          ),
          Gaps.v12,
          ...account.freeServices.map(
            (s) => _ServiceTile(service: s, catalog: catalog),
          ),
          Gaps.v40,
        ],
      ),
    );
  }
}

class _AccountHeaderCard extends StatelessWidget {
  final String identifier;
  final String provider;
  final String monthlyBill;
  final AccountIconConfig? iconConfig;

  const _AccountHeaderCard({
    required this.identifier,
    required this.provider,
    required this.monthlyBill,
    this.iconConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: iconConfig?.bg ?? AppColor.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        children: [
          Icon(
            iconConfig?.icon ?? Icons.account_circle,
            color: AppColor.white,
            size: AppSpacing.iconXl,
          ),
          Gaps.v16,
          Text(
            identifier,
            style: const TextStyle(
              color: AppColor.white,
              fontSize: AppTextSizes.xl,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.v24,
          const Divider(color: Colors.white24),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(label: 'Monthly Bill', value: monthlyBill),
              _SummaryItem(label: 'Provider', value: provider),
            ],
          ),
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
            color: AppColor.grey200,
            fontSize: AppTextSizes.sm,
          ),
        ),
        Gaps.v4,
        Text(
          value,
          style: const TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: AppTextSizes.base,
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
            fontSize: AppTextSizes.base,
            fontWeight: FontWeight.bold,
            color: AppColor.grey900,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColor.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            '$count items',
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: AppTextSizes.sm,
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
    final billingText = _getBillingText();
    final priceText = _getPriceText();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColor.grey200.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: () => context.push('/services/details/${service.service.id}'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Row(
          children: [
            // Service Icon
            Container(
              width: AppSpacing.icon56,
              height: AppSpacing.icon56,
              decoration: BoxDecoration(
                color: iconConfig.backgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(child: iconConfig.icon),
            ),
            Gaps.h16,

            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTextSizes.base,
                      color: AppColor.grey900,
                    ),
                  ),
                  if (billingText != null)
                    Text(
                      billingText,
                      style: const TextStyle(
                        color: AppColor.grey500,
                        fontSize: AppTextSizes.sm,
                      ),
                    ),
                ],
              ),
            ),

            // Price
            Text(
              priceText ?? 'Free',
              style: TextStyle(
                color: priceText != null ? AppColor.error : AppColor.success,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSizes.md,
              ),
            ),
            Gaps.h8,
            const Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSm,
              color: AppColor.grey400,
            ),
          ],
        ),
      ),
    );
  }

  String? _getBillingText() {
    if (service.isPay && service.nextBillingDate != null) {
      return billingTextFormatter(service.nextBillingDate!);
    }
    return null;
  }

  String? _getPriceText() {
    if (service.isPay && service.amount != null && service.currency != null) {
      return priceTextFormatter(service.amount!, service.currency!);
    }
    return null;
  }
}

class _ServiceIconConfig {
  final Widget icon;
  final Color backgroundColor;

  const _ServiceIconConfig({
    required this.icon,
    required this.backgroundColor,
  });
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
        child: Image.asset(
          'assets/logos/$iconKey.png',
          color: AppColor.white,
        ),
      ),
      backgroundColor: iconColor != null ? Color(iconColor) : AppColor.black,
    );
  }

  return _ServiceIconConfig(
    icon: serviceCategoryIcon[categoryKey] ??
        const Icon(Icons.category, color: AppColor.white),
    backgroundColor: AppColor.black,
  );
}
