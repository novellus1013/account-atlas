import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/formatters.dart';
import 'package:account_atlas/features/home/domain/models/category_spending_item.dart';
import 'package:account_atlas/features/home/domain/models/home_summary_read_model.dart';
import 'package:account_atlas/features/home/domain/models/upcoming_payment_item.dart';
import 'package:account_atlas/features/home/presentation/state/home_state.dart';
import 'package:account_atlas/features/home/presentation/vm/home_view_model.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:account_atlas/features/shared/widgets/d_day_badge.dart';
import 'package:account_atlas/features/shared/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColor.grey50,
      body: SafeArea(child: _buildBody(context, state, ref)),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state, WidgetRef ref) {
    return switch (state) {
      HomeLoading() => const LoadingStateWidget(),
      HomeEmpty() => EmptyStateWidget(
        icon: Icons.subscriptions_outlined,
        title: 'No services yet',
        message: 'Add your first subscription to get started',
        actionLabel: 'Add Service',
        actionIcon: Icons.add,
        onAction: () => context.push('/services/add/catalog'),
      ),
      HomeError(message: final message) => ErrorStateWidget(
        title: 'Error loading data',
        message: message,
        onRetry: () => ref.invalidate(homeViewModelProvider),
      ),
      HomeLoaded(summary: final summary) => _HomeContent(summary: summary),
    };
  }
}

class _HomeContent extends StatelessWidget {
  final HomeSummaryReadModel summary;

  const _HomeContent({required this.summary});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const _Header(),
          Gaps.v24,

          // Main Cost Card
          _CostCard(summary: summary),
          Gaps.v24,

          // Category Spending
          if (summary.categorySpending.isNotEmpty) ...[
            _CategorySpendingSection(categories: summary.categorySpending),
            Gaps.v24,
          ],

          // Upcoming Payments
          _UpcomingPaymentsSection(payments: summary.upcomingPayments),
          Gaps.v24,

          // Add Service Button
          _AddServiceButton(onTap: () => context.push('/services/add/catalog')),
          Gaps.v16,
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Atlas',
          style: TextStyle(
            fontSize: AppTextSizes.display,
            fontWeight: FontWeight.bold,
            color: AppColor.grey900,
          ),
        ),
        Gaps.v4,
        const Text(
          'Track your digital subscriptions',
          style: TextStyle(fontSize: AppTextSizes.md, color: AppColor.grey500),
        ),
      ],
    );
  }
}

class _CostCard extends StatelessWidget {
  final HomeSummaryReadModel summary;

  const _CostCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Cost
          Text(
            'Monthly Fixed Cost',
            style: TextStyle(
              fontSize: AppTextSizes.md,
              color: AppColor.white.withValues(alpha: 0.7),
            ),
          ),
          Gaps.v8,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '\$',
                style: TextStyle(
                  fontSize: AppTextSizes.xl,
                  fontWeight: FontWeight.bold,
                  color: AppColor.error,
                ),
              ),
              Gaps.h4,
              Text(
                AppFormatters.formatPrice(summary.monthlyTotalCost),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
          Gaps.v16,

          // Divider
          Container(height: 1, color: AppColor.white.withValues(alpha: 0.2)),
          Gaps.v16,

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Yearly Cost
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yearly Fixed Cost',
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    AppFormatters.formatPriceWithSymbol(
                      summary.yearlyTotalCost,
                    ),
                    style: const TextStyle(
                      fontSize: AppTextSizes.base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
              // Active Services
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Active Services',
                    style: TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    '${summary.subscriptionCount} / ${summary.totalServiceCount}',
                    style: const TextStyle(
                      fontSize: AppTextSizes.base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategorySpendingSection extends StatelessWidget {
  final List<CategorySpendingItem> categories;

  const _CategorySpendingSection({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          'Category Spending',
          style: TextStyle(
            fontSize: AppTextSizes.lg,
            fontWeight: FontWeight.bold,
            color: AppColor.grey900,
          ),
        ),
        Gaps.v16,

        // Category Grid (2 columns)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: categories.length > 4 ? 4 : categories.length,
          itemBuilder: (context, index) {
            return _CategoryCard(item: categories[index], colorIndex: index);
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategorySpendingItem item;
  final int colorIndex;

  const _CategoryCard({required this.item, required this.colorIndex});

  // Different shades of primary color for each category
  static const _categoryColors = [
    Color(0xFF1e3a8a), // primary
    Color(0xFF3b82f6),
    Color(0xFF60a5fa),
    Color(0xFF93c5fd),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _categoryColors[colorIndex % _categoryColors.length];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.category.dbCode,
                style: const TextStyle(
                  fontSize: AppTextSizes.sm,
                  color: AppColor.grey600,
                ),
              ),
              Text(
                '${item.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: AppTextSizes.xs,
                  color: AppColor.grey400,
                ),
              ),
            ],
          ),

          // Amount
          Text(
            AppFormatters.formatPriceWithSymbol(item.monthlyAmount),
            style: const TextStyle(
              fontSize: AppTextSizes.md,
              fontWeight: FontWeight.w600,
              color: AppColor.error,
            ),
          ),

          // Progress Bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColor.grey100,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: item.percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingPaymentsSection extends StatelessWidget {
  final List<UpcomingPaymentItem> payments;

  const _UpcomingPaymentsSection({required this.payments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: AppColor.grey600),
            Gaps.h8,
            const Text(
              'Upcoming Payments',
              style: TextStyle(
                fontSize: AppTextSizes.lg,
                fontWeight: FontWeight.bold,
                color: AppColor.grey900,
              ),
            ),
          ],
        ),
        Gaps.v16,

        // Payments List or Empty Message
        if (payments.isEmpty)
          _buildEmptyMessage()
        else
          ...payments.map((payment) => _UpcomingPaymentCard(payment: payment)),
      ],
    );
  }

  Widget _buildEmptyMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColor.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColor.success,
            size: 24,
          ),
          Gaps.h12,
          const Expanded(
            child: Text(
              'There are no services with upcoming payments within a week',
              style: TextStyle(
                fontSize: AppTextSizes.md,
                color: AppColor.grey700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingPaymentCard extends StatelessWidget {
  final UpcomingPaymentItem payment;

  const _UpcomingPaymentCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/services/${payment.serviceId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.basic),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColor.grey200),
        ),
        child: Row(
          children: [
            // Service Icon
            _buildServiceIcon(),
            Gaps.h12,

            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.serviceName,
                    style: const TextStyle(
                      fontSize: AppTextSizes.base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.grey900,
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    AppFormatters.formatDateReadable(payment.billingDate),
                    style: const TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.grey500,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and D-day
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppFormatters.formatPriceWithSymbol(payment.amount),
                  style: const TextStyle(
                    fontSize: AppTextSizes.md,
                    fontWeight: FontWeight.w600,
                    color: AppColor.error,
                  ),
                ),
                Gaps.v4,
                DDayBadge(dDay: payment.dDay),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon() {
    final categoryIconWidget =
        serviceCategoryIcon[payment.category.name.toLowerCase()];
    final hasCustomIcon = payment.iconKey != null;
    final backgroundColor = payment.iconColor != null
        ? Color(payment.iconColor!)
        : AppColor.black;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: hasCustomIcon
            ? Image.asset(
                'assets/logos/${payment.iconKey}.png',
                width: 24,
                height: 24,
                color: AppColor.white,
                errorBuilder: (context, error, stackTrace) =>
                    categoryIconWidget ??
                    const Icon(Icons.category, color: AppColor.white, size: 24),
              )
            : categoryIconWidget ??
                  const Icon(Icons.category, color: AppColor.white, size: 24),
      ),
    );
  }
}

class _AddServiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddServiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add Service'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.basic),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}
