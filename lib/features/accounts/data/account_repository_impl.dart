import 'package:account_atlas/features/accounts/data/account_local_datasource.dart';
import 'package:account_atlas/features/accounts/data/account_local_mapper.dart';
import 'package:account_atlas/features/accounts/domain/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDatasource local;

  AccountRepositoryImpl(this.local);

  @override
  Future<int> insertAccount(AccountEntity entity) {
    final now = DateTime.now().millisecondsSinceEpoch;

    final dto = entity.toInsertDto(now);

    return local.insertAccount(dto);
  }

  @override
  Future<AccountEntity?> getAccountById(int id) async {
    final dto = await local.getAccountById(id);
    if (dto == null) return null;

    final entity = dto.toEntity();
    return entity;
  }

  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final dtos = await local.getAllAccounts();

    final entities = dtos.map((dto) => dto.toEntity()).toList();

    return entities;
  }

  @override
  Future<int> updateAccount(AccountEntity entity) {
    final dto = entity.toUpdateDto();
    return local.updateAccount(dto);
  }

  @override
  Future<int> deleteAccount(int id) {
    return local.deleteAccount(id);
  }
}
