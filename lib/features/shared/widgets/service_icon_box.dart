import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:flutter/material.dart';

/// A reusable icon box for displaying service logos/icons.
/// Shows catalog icon if available, otherwise falls back to category icon.
class ServiceIconBox extends StatelessWidget {
  final ServiceCategory category;
  final ServiceCatalogItem? catalogItem;
  final double size;
  final double iconSize;

  const ServiceIconBox({
    super.key,
    required this.category,
    this.catalogItem,
    this.size = 56,
    this.iconSize = 32,
  });

  /// Small variant for list items
  const ServiceIconBox.small({
    super.key,
    required this.category,
    this.catalogItem,
  })  : size = AppSpacing.icon56,
        iconSize = AppSpacing.xl;

  /// Large variant for detail screens
  const ServiceIconBox.large({
    super.key,
    required this.category,
    this.catalogItem,
  })  : size = AppSpacing.icon80,
        iconSize = AppSpacing.iconXxl;

  @override
  Widget build(BuildContext context) {
    final categoryIconWidget =
        serviceCategoryIcon[category.name.toLowerCase()];
    final hasCustomIcon = catalogItem?.iconKey != null;
    final backgroundColor = catalogItem?.iconColor != null
        ? Color(catalogItem!.iconColor!)
        : AppColor.black;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: hasCustomIcon
            ? Image.asset(
                'assets/logos/${catalogItem!.iconKey}.png',
                width: iconSize,
                height: iconSize,
                color: AppColor.white,
                errorBuilder: (context, error, stackTrace) =>
                    categoryIconWidget ??
                    Icon(Icons.category, color: AppColor.white, size: iconSize),
              )
            : categoryIconWidget ??
                Icon(Icons.category, color: AppColor.white, size: iconSize),
      ),
    );
  }
}
