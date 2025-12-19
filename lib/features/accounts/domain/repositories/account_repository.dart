//설계도 - entity만 알고 있다.
import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

abstract class AccountRepository {
  Future<int> insertAccount(AccountEntity account);
  Future<AccountEntity?> getAccountById(int id);
  Future<List<AccountEntity>> getAllAccounts();
  Future<int> updateAccount(AccountEntity account);
  Future<int> deleteAccount(int id);
}
