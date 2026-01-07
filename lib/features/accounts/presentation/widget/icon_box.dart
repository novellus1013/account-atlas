import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final Color color;
  final IconData icon;

  const IconBox({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xl + AppSpacing.lg,
      height: AppSpacing.xl + AppSpacing.lg,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.basic),
        color: color,
      ),
      child: Center(
        child: Icon(icon, size: AppSpacing.xl, color: AppColor.white),
      ),
    );
  }
}
