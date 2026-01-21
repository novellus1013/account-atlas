import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class SaveService {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  SaveService(this.serviceRepo, this.planRepo);

  Future<int> call(ServiceDetailReadModel all) async {
    final int accountServiceId;
    final service = all.service;
    final plan = all.plan;

    if (service.id == null) {
      accountServiceId = await serviceRepo.insertService(service);
    } else {
      await serviceRepo.updateService(service);
      accountServiceId = service.id!;
    }

    if (service.isPay && plan != null) {
      final planToSave = plan.bindToAccountService(accountServiceId);
      await planRepo.upsertPlan(planToSave);
    } else {
      // Try to delete any existing plan, but ignore if none exists
      try {
        await planRepo.deletePlan(accountServiceId);
      } on PlanNotFound {
        // No plan exists - this is expected for new non-subscription services
      }
    }

    return accountServiceId;
  }
}
