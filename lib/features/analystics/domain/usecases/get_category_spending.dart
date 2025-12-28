import 'package:account_atlas/features/analystics/domain/entities/category_spending_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class GetCategorySpending {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  GetCategorySpending(this.serviceRepo, this.planRepo);

  Future<List<CategorySpendingEntity>> call() async {
    final services = await serviceRepo.getAllServices();
    final paidServices = services.where((e) => e.isPay).toList();

    final Map<ServiceCategory, int> categoryTotals = {
      for (final count in ServiceCategory.values) count: 0,
    };

    //구독료 카테고리에 할당
    for (final service in paidServices) {
      final accountServiceId = service.id;
      if (accountServiceId == null) continue;

      final plan = await planRepo.getPlanByAccountServiceId(accountServiceId);

      final amountPerMonth = plan.billingCycle == BillingCycle.monthly
          ? plan.amount
          : plan.amount ~/ 12;

      final category = service.category;

      categoryTotals[category] =
          (categoryTotals[category] ?? 0) + amountPerMonth;
    }

    // 구독료 전체 합산
    final monthlyTotal = categoryTotals.values.fold(
      0,
      (prev, element) => prev + element,
    );

    if (monthlyTotal == 0) {
      return [];
    }

    // CategorySpendingEntity 리스트
    final result = categoryTotals.entries.map((e) {
      final category = e.key;
      final categoryMonthlyTotal = e.value;

      return CategorySpendingEntity(
        category,
        categoryMonthlyTotal,
        monthlyTotal,
      );
    }).toList();

    // 월 구독료 크기 순으로 정렬, 동점이면 이름 순
    result.sort(
      (a, b) => b.categoryMonthlyTotal.compareTo(b.categoryMonthlyTotal),
    );

    return result;
  }
}
