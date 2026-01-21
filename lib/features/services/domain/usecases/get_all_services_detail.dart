import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetAllServicesDetail {
  final ServiceRepository _serviceRepo;
  final PlanRepository _planRepo;

  GetAllServicesDetail(this._serviceRepo, this._planRepo);

  Future<List<ServiceDetailReadModel>> call() async {
    final services = await _serviceRepo.getAllServices();

    final List<ServiceDetailReadModel> result = [];

    for (final service in services) {
      final accountServiceId = service.id;
      if (accountServiceId == null) continue;

      // Try to get plan, but it's okay if it doesn't exist (non-subscription services)
      PlanEntity? plan;
      try {
        plan = await _planRepo.getPlanByAccountServiceId(accountServiceId);
      } on PlanNotFound {
        // Service has no plan - this is valid for non-subscription services
        plan = null;
      }

      result.add(ServiceDetailReadModel(service: service, plan: plan));
    }

    return result;
  }
}
