import 'package:account_atlas/features/services/domain/services_enums.dart';

class CategorySpendingEntity {
  final ServiceCategory category;
  final int categoryMonthlyTotal;
  final int monthlyTotal;

  CategorySpendingEntity(
    this.category,
    this.categoryMonthlyTotal,
    this.monthlyTotal,
  );
}
