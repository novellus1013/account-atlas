import 'package:account_atlas/features/accounts/domain/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/account_repository.dart';

class CreateAccount {
  final AccountRepository repo;

  CreateAccount(this.repo);

  Future<int> call(AccountEntity account) {
    return repo.insertAccount(account);
  }
}
