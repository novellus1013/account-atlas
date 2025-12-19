import 'package:account_atlas/features/accounts/domain/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/account_repository.dart';

class UpdateAccount {
  final AccountRepository repo;

  UpdateAccount(this.repo);

  Future<int> call(AccountEntity account) {
    return repo.updateAccount(account);
  }
}
