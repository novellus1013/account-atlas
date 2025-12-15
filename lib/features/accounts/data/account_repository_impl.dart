import 'package:account_atlas/features/accounts/data/account_local_datasource.dart';
import 'package:account_atlas/features/accounts/data/account_local_dto.dart';
import 'package:account_atlas/features/accounts/domain/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDatasource datasource;

  AccountRepositoryImpl(this.datasource);

  @override
  Future<int> insertAccount(AccountEntity entity) {
    final now = DateTime.now().millisecondsSinceEpoch;

    final dto = AccountLocalDto(
      identifier: entity.identifier,
      provider: entity.provider,
      createdAt: now,
    );

    return datasource.insertAccount(dto);
  }

  @override
  Future<AccountEntity?> getAccountById(int id) async {
    final dto = await datasource.getAccountById(id);
    if (dto == null) return null;

    final entity = AccountEntity(
      id: dto.id,
      identifier: dto.identifier,
      provider: dto.provider,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dto.createdAt!),
    );
    return entity;
  }

  @override
  Future<List<AccountEntity>> getAllAccounts() async {
    final dtos = await datasource.getAllAccounts();

    final entities = dtos
        .map(
          (dto) => AccountEntity(
            id: dto.id,
            identifier: dto.identifier,
            provider: dto.provider,
            createdAt: DateTime.fromMillisecondsSinceEpoch(dto.createdAt!),
          ),
        )
        .toList();

    return entities;
  }

  @override
  Future<int> updateAccount(AccountEntity entity) {
    final dto = AccountLocalDto(
      id: entity.id,
      identifier: entity.identifier,
      provider: entity.provider,
    );
    return datasource.updateAccount(dto);
  }

  @override
  Future<int> deleteAccount(int id) {
    return datasource.deleteAccount(id);
  }
}
