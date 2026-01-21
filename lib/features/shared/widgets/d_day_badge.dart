import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/utils/billing_calculator.dart';
import 'package:flutter/material.dart';

/// A badge widget displaying D-day countdown for upcoming payments.
/// Used in services list, upcoming payments, and detail screens.
class DDayBadge extends StatelessWidget {
  final int dDay;
  final bool isLarge;

  const DDayBadge({
    super.key,
    required this.dDay,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DDayColors.fromDDay(dDay);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? AppSpacing.basic : AppSpacing.sm,
        vertical: isLarge ? 10 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(
          isLarge ? AppSpacing.radiusMd : AppSpacing.xs,
        ),
      ),
      child: Text(
        DDayColors.formatDDay(dDay),
        style: TextStyle(
          fontSize: isLarge ? AppTextSizes.lg : AppTextSizes.sm,
          fontWeight: FontWeight.w600,
          color: colors.textColor,
        ),
      ),
    );
  }
}
