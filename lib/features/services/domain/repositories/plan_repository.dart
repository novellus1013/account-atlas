import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';

abstract class PlanRepository {
  Future<int> upsertPlan(PlanEntity plan);
  Future<PlanEntity> getPlanByAccountServiceId(int accountServiceId);
  Future<int> deletePlan(int accountServiceId);
}
