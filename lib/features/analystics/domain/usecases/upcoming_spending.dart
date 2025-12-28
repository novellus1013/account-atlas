import 'package:account_atlas/features/analystics/domain/entities/upcoming_spending_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class UpcomingSpending {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  UpcomingSpending(this.serviceRepo, this.planRepo);

  Future<List<UpcomingSpendingEntity>> call() async {
    final services = await serviceRepo.getAllServices();
    final paidServices = services.where((e) => e.isPay).toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime truncateToDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final List<UpcomingSpendingEntity> items = [];

    for (final service in paidServices) {
      if (service.id == null) continue;

      final plan = await planRepo.getPlanByAccountServiceId(service.id!);
      if (plan == null) continue;

      DateTime next = truncateToDate(plan.nextBillingDate);

      final cycle = plan.billingCycle;

      while (!next.isAfter(today)) {
        if (cycle == BillingCycle.monthly) {
          next = DateTime(next.year, next.month + 1, next.day);
        } else {
          next = DateTime(next.year + 1, next.month, next.day);
        }
      }

      items.add(
        UpcomingSpendingEntity(
          service.category,
          service.displayName,
          next,
          plan.amount,
        ),
      );
    }

    return items;
  }
}
