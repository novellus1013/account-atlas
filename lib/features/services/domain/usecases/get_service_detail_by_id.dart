import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetServiceDetailById {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  GetServiceDetailById(this.serviceRepo, this.planRepo);

  Future<ServiceDetailReadModel> call(int serviceId) async {
    final service = await serviceRepo.getServiceById(serviceId);

    // Try to get plan, but it's optional (free services don't have plans)
    PlanEntity? plan;
    try {
      plan = await planRepo.getPlanByAccountServiceId(serviceId);
    } on PlanNotFound {
      plan = null;
    }

    return ServiceDetailReadModel(service: service, plan: plan);
  }
}
