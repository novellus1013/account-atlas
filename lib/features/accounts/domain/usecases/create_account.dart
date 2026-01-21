import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';

class CreateAccount {
  final AccountRepository repo;

  CreateAccount(this.repo);

  Future<int> call(AccountEntity account) {
    return repo.insertAccount(account);
  }
}
