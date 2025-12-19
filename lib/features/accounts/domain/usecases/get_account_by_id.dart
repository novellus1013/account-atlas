import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';

class GetAccountById {
  final AccountRepository repo;

  GetAccountById(this.repo);

  Future<AccountEntity?> call(int id) {
    return repo.getAccountById(id);
  }
}
