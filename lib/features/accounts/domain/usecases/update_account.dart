import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';

class UpdateAccount {
  final AccountRepository repo;

  UpdateAccount(this.repo);

  Future<int> call(AccountEntity account) {
    return repo.updateAccount(account);
  }
}
