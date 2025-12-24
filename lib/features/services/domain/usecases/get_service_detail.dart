import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetServiceDetail {
  final ServiceRepository serviceRepo;
  final PlanRepository planRepo;

  GetServiceDetail(this.serviceRepo, this.planRepo);

  Future<ServiceDetail?> call(int serviceId) async {
    final service = await serviceRepo.getServiceById(serviceId);
    if (service == null) return null;

    final plan = await planRepo.getPlanByAccountServiceId(serviceId);

    return ServiceDetail(service: service, plan: plan);
  }
}

class ServiceDetail {
  final ServiceEntity service;
  final PlanEntity? plan;

  ServiceDetail({required this.service, this.plan});
}
