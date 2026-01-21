import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class Gaps {
  const Gaps._();

  // Vertical Gaps
  static const v4 = SizedBox(height: AppSpacing.xs);
  static const v8 = SizedBox(height: AppSpacing.sm);
  static const v12 = SizedBox(height: AppSpacing.md);
  static const v16 = SizedBox(height: AppSpacing.basic);
  static const v20 = SizedBox(height: AppSpacing.lg20);
  static const v24 = SizedBox(height: AppSpacing.lg);
  static const v32 = SizedBox(height: AppSpacing.xl);
  static const v40 = SizedBox(height: AppSpacing.xxl);

  // Horizontal Gaps
  static const h4 = SizedBox(width: AppSpacing.xs);
  static const h8 = SizedBox(width: AppSpacing.sm);
  static const h12 = SizedBox(width: AppSpacing.md);
  static const h16 = SizedBox(width: AppSpacing.basic);
  static const h20 = SizedBox(width: AppSpacing.lg20);
  static const h24 = SizedBox(width: AppSpacing.lg);
  static const h32 = SizedBox(width: AppSpacing.xl);
  static const h40 = SizedBox(width: AppSpacing.xxl);
}
