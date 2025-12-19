import 'package:account_atlas/features/accounts/domain/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/account_repository.dart';

class GetAllAccounts {
  final AccountRepository repo;

  GetAllAccounts(this.repo);

  Future<List<AccountEntity>> call() {
    return repo.getAllAccounts();
  }
}
