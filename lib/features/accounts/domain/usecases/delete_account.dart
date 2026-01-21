import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';

class DeleteAccount {
  final AccountRepository repo;

  DeleteAccount(this.repo);

  Future<int> call(int id) {
    return repo.deleteAccount(id);
  }
}
