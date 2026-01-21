import 'package:account_atlas/core/storage/app_database.dart';
import 'package:account_atlas/features/services/data/dtos/service_local_dto.dart';
import 'package:sqflite/sqflite.dart';

class ServiceLocalDatasource {
  Future<Database> get _db async {
    return AppDatabase.instance.database;
  }

  Future<int> insertService(ServiceLocalDto dto) async {
    final db = await _db;

    return await db.insert(
      'account_services',
      dto.toInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ServiceLocalDto?> getServiceById(int id) async {
    final db = await _db;
    final result = await db.query(
      'account_services',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ServiceLocalDto.fromMap(result.first);
  }

  Future<List<ServiceLocalDto>> getServicesByAccount(int accountId) async {
    final db = await _db;
    final result = await db.query(
      'account_services',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'created_at DESC',
    );

    return result.map((e) => ServiceLocalDto.fromMap(e)).toList();
  }

  Future<List<ServiceLocalDto>> getAllServices() async {
    final db = await _db;
    final result = await db.query(
      'account_services',
      orderBy: 'created_at DESC',
    );

    return result.map((e) => ServiceLocalDto.fromMap(e)).toList();
  }

  Future<int> updateService(ServiceLocalDto dto) async {
    final db = await _db;

    return await db.update(
      'account_services',
      dto.toUpdateMap(),
      where: 'id = ?',
      whereArgs: [dto.id],
    );
  }

  Future<int> deleteService(int id) async {
    final db = await _db;

    return await db.delete(
      'account_services',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
