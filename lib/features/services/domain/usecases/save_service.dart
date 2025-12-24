import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class SaveService {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  SaveService(this.serviceRepo, this.planRepo);

  Future<int> call({required ServiceEntity service, PlanEntity? plan}) async {
    final int accountServiceId;

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
      await planRepo.deletePlan(accountServiceId);
    }

    return accountServiceId;
  }
}
