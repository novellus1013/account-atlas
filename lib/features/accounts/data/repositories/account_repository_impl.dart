import 'package:account_atlas/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:account_atlas/features/accounts/data/mappers/account_local_mapper.dart';
import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDatasource local;

  AccountRepositoryImpl(this.local);

  @override
  Future<int> insertAccount(AccountEntity entity) {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final dto = entity.toInsertDto(now);

      return local.insertAccount(dto);
    } on AccountFailure {
      rethrow;
    } catch (e) {
      throw AccountStorageFailure();
    }
  }

  @override
  Future<AccountEntity> getAccountById(int id) async {
    try {
      final dto = await local.getAccountById(id);
      if (dto == null) {
        throw AccountNotFound();
      }
      final entity = dto.toEntity();

      return entity;
    } on AccountFailure {
      rethrow;
    } catch (e) {
      throw AccountStorageFailure();
    }
  }

  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    try {
      final dtos = await local.getAllAccounts();
      final entities = dtos.map((dto) => dto.toEntity()).toList();

      return entities;
    } on AccountFailure {
      rethrow;
    } catch (e) {
      throw AccountStorageFailure();
    }
  }

  @override
  Future<int> updateAccount(AccountEntity entity) async {
    try {
      final dto = entity.toUpdateDto();
      final result = await local.updateAccount(dto);

      if (result == 0) {
        throw AccountNotFound();
      } else {
        return result;
      }
    } on AccountFailure {
      rethrow;
    } catch (e) {
      throw AccountStorageFailure();
    }
  }

  @override
  Future<int> deleteAccount(int id) async {
    try {
      final result = await local.deleteAccount(id);

      if (result == 0) {
        throw AccountNotFound();
      } else {
        return result;
      }
    } on AccountFailure {
      rethrow;
    } catch (e) {
      throw AccountStorageFailure();
    }
  }
}
