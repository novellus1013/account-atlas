import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/billing_calculator.dart';
import 'package:account_atlas/core/utils/formatters.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/shared/widgets/d_day_badge.dart';
import 'package:account_atlas/features/shared/widgets/service_icon_box.dart';
import 'package:flutter/material.dart';

/// A card widget displaying service information in a list.
/// Shows service icon, name, category, price, and D-day badge.
class ServiceCard extends StatelessWidget {
  final ServiceDetailReadModel service;
  final Map<String, ServiceCatalogItem> catalog;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.catalog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final serviceEntity = service.service;
    final plan = service.plan;
    final catalogItem = serviceEntity.providedServiceKey != null
        ? catalog[serviceEntity.providedServiceKey]
        : null;

    int? dDay;
    String? nextBillingLabel;
    if (plan != null) {
      dDay = BillingCalculator.calculateDDay(plan.nextBillingDate);
      nextBillingLabel = AppFormatters.formatDate(
        BillingCalculator.computeNextBillingDate(plan.nextBillingDate),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.basic),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColor.grey200),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ServiceIconBox.small(
              category: serviceEntity.category,
              catalogItem: catalogItem,
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameRow(serviceEntity),
                  Gaps.v4,
                  Text(
                    serviceEntity.category.dbCode,
                    style: const TextStyle(
                      fontSize: AppTextSizes.sm,
                      color: AppColor.grey500,
                    ),
                  ),
                  if (plan != null) ...[
                    Gaps.v8,
                    _buildPriceRow(plan, nextBillingLabel, dDay),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameRow(ServiceEntity serviceEntity) {
    return Row(
      children: [
        Expanded(
          child: Text(
            serviceEntity.displayName,
            style: const TextStyle(
              fontSize: AppTextSizes.base,
              fontWeight: FontWeight.w600,
              color: AppColor.grey900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (serviceEntity.isPay) ...[
          Gaps.h8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: const Text(
              'Subscription',
              style: TextStyle(
                fontSize: AppTextSizes.xs,
                fontWeight: FontWeight.w500,
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceRow(PlanEntity plan, String? nextBillingLabel, int? dDay) {
    return Row(
      children: [
        Text(
          AppFormatters.formatPriceWithSymbol(plan.amount),
          style: const TextStyle(
            fontSize: AppTextSizes.md,
            fontWeight: FontWeight.w600,
            color: AppColor.grey900,
          ),
        ),
        Text(
          '/${plan.billingCycle == BillingCycle.yearly ? 'year' : 'month'}',
          style: const TextStyle(
            fontSize: AppTextSizes.sm,
            color: AppColor.grey500,
          ),
        ),
        const Spacer(),
        if (nextBillingLabel != null) ...[
          Text(
            nextBillingLabel,
            style: const TextStyle(
              fontSize: AppTextSizes.sm,
              color: AppColor.grey500,
            ),
          ),
          Gaps.h8,
        ],
        if (dDay != null) DDayBadge(dDay: dDay),
      ],
    );
  }
}
