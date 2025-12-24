import 'package:account_atlas/features/services/data/datasources/plan_local_datasource.dart';
import 'package:account_atlas/features/services/data/mappers/plan_local_mapper.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanLocalDatasource local;

  PlanRepositoryImpl(this.local);

  @override
  Future<int> deletePlan(int accountServiceId) async {
    try {
      final result = await local.deletePlan(accountServiceId);

      if (result == 0) {
        throw PlanNotFound();
      } else {
        return result;
      }
    } on PlanFailure {
      rethrow;
    } catch (e) {
      throw PlanStorageFailure();
    }
  }

  @override
  Future<PlanEntity?> getPlanByAccountServiceId(int accountServiceId) async {
    try {
      final dto = await local.getPlanByAccountServiceId(accountServiceId);
      if (dto == null) {
        throw PlanNotFound();
      }

      return dto.toEntity();
    } on PlanFailure {
      rethrow;
    } catch (e) {
      throw PlanStorageFailure();
    }
  }

  @override
  Future<int> upsertPlan(PlanEntity entity) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final existing = await local.getPlanByAccountServiceId(
        entity.accountServiceId,
      );
      if (existing == null) {
        final dto = entity.toInsertDto(now);
        return local.insertPlan(dto);
      } else {
        final dto = entity.toUpdateDto();
        return local.updatePlan(dto);
      }
    } on PlanFailure {
      rethrow;
    } catch (e) {
      throw PlanStorageFailure();
    }
  }
}
