import 'package:account_atlas/core/storage/app_database.dart';
import 'package:account_atlas/features/services/data/dtos/plan_local_dto.dart';
import 'package:sqflite/sqlite_api.dart';

class PlanLocalDatasource {
  Future<Database> get _db async {
    return AppDatabase.instance.database;
  }

  Future<int> insertPlan(PlanLocalDto dto) async {
    final db = await _db;

    return await db.insert(
      'plans',
      dto.toInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PlanLocalDto?> getPlanByAccountServiceId(int accountServiceId) async {
    final db = await _db;
    final result = await db.query(
      'plans',
      where: 'account_service_id = ?',
      whereArgs: [accountServiceId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return PlanLocalDto.fromMap(result.first);
  }

  Future<int> updatePlan(PlanLocalDto dto) async {
    final db = await _db;

    return await db.update(
      'plans',
      dto.toUpdateMap(),
      where: 'id = ?',
      whereArgs: [dto.id],
    );
  }

  Future<int> deletePlan(int accountServiceId) async {
    final db = await _db;

    return await db.delete(
      'plans',
      where: 'account_service_id = ?',
      whereArgs: [accountServiceId],
    );
  }
}
