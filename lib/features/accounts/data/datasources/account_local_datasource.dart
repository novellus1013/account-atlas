import 'package:account_atlas/core/storage/app_database.dart';
import 'package:account_atlas/features/accounts/data/dtos/account_local_dto.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountLocalDatasource {
  Future<Database> get _db async {
    return AppDatabase.instance.database;
  }

  Future<int> insertAccount(AccountLocalDto dto) async {
    final db = await _db;

    return await db.insert(
      'accounts',
      dto.toInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AccountLocalDto?> getAccountById(int id) async {
    final db = await _db;
    final result = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return AccountLocalDto.fromMap(result.first);
  }

  Future<List<AccountLocalDto>> getAllAccounts() async {
    final db = await _db;
    final result = await db.query('accounts', orderBy: 'created_at DESC');

    return result.map((e) => AccountLocalDto.fromMap(e)).toList();
  }

  Future<int> updateAccount(AccountLocalDto dto) async {
    final db = await _db;

    return await db.update(
      'accounts',
      dto.toUpdateMap(),
      where: 'id = ?',
      whereArgs: [dto.id],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await _db;

    return await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }
}
