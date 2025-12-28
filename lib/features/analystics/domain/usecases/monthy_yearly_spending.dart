import 'package:account_atlas/features/analystics/domain/entities/monthly_yearly_spending_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class MonthyYearlySpending {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  MonthyYearlySpending(this.serviceRepo, this.planRepo);

  Future<MonthlyYearlySpendingEntity> call() async {
    final services = await serviceRepo.getAllServices();
    final totalServices = services.length;

    final paidServices = services.where((e) => e.isPay).toList();
    final totalPaidServices = paidServices.length;

    int monthlyTotal = 0;
    int yearlyTotal = 0;

    for (final service in paidServices) {
      if (service.id == null) continue;

      final plan = await planRepo.getPlanByAccountServiceId(service.id!);
      if (plan == null) continue;

      final amount = plan.amount;

      if (plan.billingCycle == BillingCycle.monthly) {
        monthlyTotal += amount;
        yearlyTotal += amount * 12;
      } else {
        yearlyTotal += amount;
        monthlyTotal += amount ~/ 12;
      }
    }

    return MonthlyYearlySpendingEntity(
      monthlyTotal,
      yearlyTotal,
      totalServices,
      totalPaidServices,
    );
  }
}
