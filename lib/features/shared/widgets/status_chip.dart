import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:flutter/material.dart';

/// A reusable chip widget for displaying status labels.
/// Used for category badges, subscription badges, etc.
class StatusChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  /// Creates a grey chip for neutral/category labels.
  const StatusChip.grey({
    super.key,
    required this.label,
    this.padding,
  })  : backgroundColor = AppColor.grey100,
        textColor = AppColor.grey600;

  /// Creates a primary-colored chip for highlighted labels.
  StatusChip.primary({
    super.key,
    required this.label,
    this.padding,
  })  : backgroundColor = AppColor.primary.withValues(alpha: 0.1),
        textColor = AppColor.primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 6,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.grey100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTextSizes.sm,
          color: textColor ?? AppColor.grey600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
