import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class DeleteService {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  DeleteService(this.serviceRepo, this.planRepo);

  Future<int> call(int serviceId) async {
    await planRepo.deletePlan(serviceId);
    return serviceRepo.deleteService(serviceId);
  }
}
