import 'package:account_atlas/features/services/domain/services_enums.dart';

/// Represents spending data for a single category.
class CategorySpendingItem {
  final ServiceCategory category;
  final int monthlyAmount;
  final double percentage;

  const CategorySpendingItem({
    required this.category,
    required this.monthlyAmount,
    required this.percentage,
  });
}
