import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/billing_calculator.dart';
import 'package:account_atlas/core/utils/formatters.dart';
import 'package:account_atlas/core/utils/ui_helpers.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/presentation/provider/accounts_provider.dart';
import 'package:account_atlas/features/accounts/presentation/vm/account_detail_view_model.dart';
import 'package:account_atlas/features/home/presentation/vm/home_view_model.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/services/presentation/state/service_detail_state.dart';
import 'package:account_atlas/features/services/presentation/vm/service_detail_view_model.dart';
import 'package:account_atlas/features/shared/widgets/action_buttons_bar.dart';
import 'package:account_atlas/features/shared/widgets/service_icon_box.dart';
import 'package:account_atlas/features/shared/widgets/state_widgets.dart';
import 'package:account_atlas/features/shared/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const ServiceDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  AccountEntity? _linkedAccount;

  int get _serviceId => int.parse(widget.id);

  @override
  void initState() {
    super.initState();
    _loadLinkedAccount();
  }

  Future<void> _loadLinkedAccount() async {
    final state = ref.read(serviceDetailViewmodelProvider(_serviceId));
    if (state is ServiceDetailLoaded) {
      await _fetchAccount(state.service.service.accountId);
    }
  }

  Future<void> _fetchAccount(int accountId) async {
    try {
      final getAccountById = ref.read(getAccountByIdProvider);
      final account = await getAccountById.call(accountId);
      if (mounted) {
        setState(() => _linkedAccount = account);
      }
    } catch (e) {
      // Account not found or error - leave as null
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showWarningPopDialog(
      context,
      'Delete Service',
      'Are you sure you want to delete this service? This action cannot be undone.',
      'Delete',
    );

    if (confirm != true || !context.mounted) return;

    await ref
        .read(serviceDetailViewmodelProvider(_serviceId).notifier)
        .delete(_serviceId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceDetailViewmodelProvider(_serviceId));
    final catalogAsync = ref.watch(serviceCatalogProvider);

    final catalog = catalogAsync.when(
      data: (data) => data,
      loading: () => <String, ServiceCatalogItem>{},
      error: (e, s) => <String, ServiceCatalogItem>{},
    );

    ref.listen(serviceDetailViewmodelProvider(_serviceId), (previous, next) {
      if (next is ServiceDetailDeleted && context.mounted) {
        if (previous is ServiceDetailLoaded) {
          final accountId = previous.service.service.accountId;
          ref.invalidate(accountDetailViewModelProvider(accountId));
        }
        ref.invalidate(homeViewModelProvider);
        context.pop();
      }
      if (next is ServiceDetailLoaded && _linkedAccount == null) {
        _fetchAccount(next.service.service.accountId);
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
      body: SafeArea(child: _buildBody(state, catalog)),
    );
  }

  Widget _buildBody(
    ServiceDetailState state,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    return switch (state) {
      ServiceDetailLoading() => const LoadingStateWidget(),
      ServiceDetailError(message: final message) => ErrorStateWidget(
        title: 'Error loading service',
        message: message,
        onRetry: () =>
            ref.invalidate(serviceDetailViewmodelProvider(_serviceId)),
      ),
      ServiceDetailDeleted() => const Center(child: Text('Service deleted')),
      ServiceDetailLoaded(service: final serviceDetail) => _buildContent(
        serviceDetail,
        catalog,
      ),
    };
  }

  Widget _buildContent(
    ServiceDetailReadModel serviceDetail,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    final service = serviceDetail.service;
    final plan = serviceDetail.plan;
    final catalogItem = service.providedServiceKey != null
        ? catalog[service.providedServiceKey]
        : null;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.basic),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServiceHeaderCard(service: service, catalogItem: catalogItem),
                Gaps.v24,
                if (service.isPay && plan != null) ...[
                  _CostInfoSection(plan: plan),
                  Gaps.v24,
                  _NextPaymentSection(plan: plan),
                  Gaps.v24,
                ] else ...[
                  const _FreeServiceSection(),
                  Gaps.v24,
                ],
                _DetailsSection(
                  service: service,
                  plan: plan,
                  linkedAccount: _linkedAccount,
                ),
              ],
            ),
          ),
        ),
        ActionButtonsBar(
          onEdit: () => context.push(
            '/services/details/${widget.id}/edit/catalog?accountId=${service.accountId}',
          ),
          onDelete: () => _confirmDelete(context),
        ),
      ],
    );
  }
}

class _ServiceHeaderCard extends StatelessWidget {
  final ServiceEntity service;
  final ServiceCatalogItem? catalogItem;

  const _ServiceHeaderCard({required this.service, this.catalogItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ServiceIconBox.large(
            category: service.category,
            catalogItem: catalogItem,
          ),
          Gaps.v16,

          // Service Name
          Text(
            service.displayName,
            style: const TextStyle(
              fontSize: AppTextSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColor.grey900,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.v12,

          // Chips Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusChip.grey(label: service.category.dbCode),
              if (service.isPay) ...[
                Gaps.h8,
                StatusChip.primary(label: 'Subscription'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CostInfoSection extends StatelessWidget {
  final PlanEntity plan;

  const _CostInfoSection({required this.plan});

  @override
  Widget build(BuildContext context) {
    final monthlyPrice = plan.amount;
    final yearlyPrice = monthlyPrice * 12;
    final totalSpent = BillingCalculator.calculateTotalSpent(
      subscriptionStartDate: plan.createdAt,
      nextBillingDate: plan.nextBillingDate,
      monthlyAmount: plan.amount,
    );
    final billingCycleLabel = plan.billingCycle == BillingCycle.yearly
        ? 'Yearly'
        : 'Monthly';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cost Information',
            style: TextStyle(
              fontSize: AppTextSizes.lg,
              fontWeight: FontWeight.bold,
              color: AppColor.grey900,
            ),
          ),
          Gaps.v16,
          _CostInfoRow(label: 'Billing Cycle', value: billingCycleLabel),
          Gaps.v12,
          _CostInfoRow(
            label: 'Monthly Price',
            value: AppFormatters.formatPriceWithSymbol(monthlyPrice),
            valueColor: AppColor.error,
          ),
          Gaps.v12,
          _CostInfoRow(
            label: 'Yearly Price',
            value: AppFormatters.formatPriceWithSymbol(yearlyPrice),
            valueColor: AppColor.error,
          ),
          const Divider(height: 24),
          _CostInfoRow(
            label: 'Since subscription started',
            value: AppFormatters.formatPriceWithSymbol(totalSpent),
            valueColor: AppColor.primary,
          ),
        ],
      ),
    );
  }
}

class _CostInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CostInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTextSizes.md,
            color: AppColor.grey500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTextSizes.md,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColor.grey900,
          ),
        ),
      ],
    );
  }
}

class _NextPaymentSection extends StatelessWidget {
  final PlanEntity plan;

  const _NextPaymentSection({required this.plan});

  @override
  Widget build(BuildContext context) {
    final nextBillingDate = BillingCalculator.computeNextBillingDate(
      plan.nextBillingDate,
    );
    final dDay = BillingCalculator.calculateDDay(plan.nextBillingDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColor.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppSpacing.iconMd,
                color: AppColor.secondary,
              ),
              Gaps.h8,
              const Text(
                'Next Payment',
                style: TextStyle(
                  fontSize: AppTextSizes.lg,
                  fontWeight: FontWeight.bold,
                  color: AppColor.grey900,
                ),
              ),
            ],
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Date',
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.grey500,
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    AppFormatters.formatDate(nextBillingDate),
                    style: const TextStyle(
                      fontSize: AppTextSizes.lg,
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey900,
                    ),
                  ),
                ],
              ),
              // D-day Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.basic,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.secondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Text(
                  DDayColors.formatDDay(dDay),
                  style: const TextStyle(
                    fontSize: AppTextSizes.lg,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FreeServiceSection extends StatelessWidget {
  const _FreeServiceSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColor.success),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.savings_outlined,
                size: AppSpacing.iconMd,
                color: AppColor.success,
              ),
              Gaps.h8,
              const Text(
                'Cost Information',
                style: TextStyle(
                  fontSize: AppTextSizes.lg,
                  fontWeight: FontWeight.bold,
                  color: AppColor.grey900,
                ),
              ),
            ],
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Type',
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.grey500,
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    'Free Service',
                    style: TextStyle(
                      fontSize: AppTextSizes.lg,
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey900,
                    ),
                  ),
                ],
              ),
              // Free Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.basic,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: AppSpacing.iconSm + 2,
                      color: AppColor.success,
                    ),
                    Gaps.h8,
                    Text(
                      '\$0',
                      style: TextStyle(
                        fontSize: AppTextSizes.lg,
                        fontWeight: FontWeight.bold,
                        color: AppColor.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final ServiceEntity service;
  final PlanEntity? plan;
  final AccountEntity? linkedAccount;

  const _DetailsSection({required this.service, this.plan, this.linkedAccount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: AppTextSizes.lg,
              fontWeight: FontWeight.bold,
              color: AppColor.grey900,
            ),
          ),
          Gaps.v16,

          // Linked Account (tappable)
          _AccountRow(
            accountId: service.accountId,
            identifier: linkedAccount?.identifier,
          ),
          Gaps.v16,

          // Login Type
          _DetailRow(
            icon: Icons.login,
            label: 'Login Type',
            value: service.loginType.dbCode,
          ),
          if (service.loginId != null && service.loginId!.isNotEmpty) ...[
            Gaps.v16,
            _DetailRow(
              icon: Icons.person_outline,
              label: 'Login ID',
              value: service.loginId!,
            ),
          ],

          // Memo
          const Divider(height: 24),
          _DetailRow(
            icon: Icons.note_outlined,
            label: 'Memo',
            value: service.memo?.isNotEmpty == true ? service.memo! : '-',
          ),
          const Divider(height: 24),

          // Service Added Date
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Service Added Date',
            value: service.createdAt != null
                ? AppFormatters.formatDate(service.createdAt!)
                : '-',
          ),

          // Subscription Start Date
          if (plan?.createdAt != null) ...[
            Gaps.v16,
            _DetailRow(
              icon: Icons.play_circle_outline,
              label: 'Subscription Start',
              value: AppFormatters.formatDate(plan!.createdAt!),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final int accountId;
  final String? identifier;

  const _AccountRow({required this.accountId, this.identifier});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/accounts/$accountId/detail'),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: AppSpacing.iconMd,
              color: AppColor.grey500,
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.grey500,
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    identifier ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: AppTextSizes.md,
                      fontWeight: FontWeight.w500,
                      color: AppColor.grey900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _DetailRow({required this.icon, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSpacing.iconMd, color: AppColor.grey500),
        Gaps.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppTextSizes.sm,
                  color: AppColor.grey500,
                ),
              ),
              Gaps.v4,
              Text(
                value ?? '-',
                style: const TextStyle(
                  fontSize: AppTextSizes.md,
                  fontWeight: FontWeight.w500,
                  color: AppColor.grey900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
