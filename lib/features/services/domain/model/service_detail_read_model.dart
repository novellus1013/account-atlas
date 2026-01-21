import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';

class ServiceDetailReadModel {
  final ServiceEntity service;
  final PlanEntity? plan;

  ServiceDetailReadModel({required this.service, this.plan});
}
