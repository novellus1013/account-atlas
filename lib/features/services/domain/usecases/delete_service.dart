import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class DeleteService {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  DeleteService(this.serviceRepo, this.planRepo);

  Future<int> call(int serviceId) async {
    // Try to delete plan, but ignore if none exists (free services)
    try {
      await planRepo.deletePlan(serviceId);
    } on PlanNotFound {
      // No plan exists - this is expected for free services
    }
    return serviceRepo.deleteService(serviceId);
  }
}
