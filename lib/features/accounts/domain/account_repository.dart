import 'package:account_atlas/features/accounts/domain/account_entity.dart';

//설계도 - entity만 알고 있다.
abstract class AccountRepository {
  Future<int> insertAccount(AccountEntity account);
  Future<AccountEntity?> getAccountById(int id);
  Future<List<AccountEntity>> getAllAccounts();
  Future<int> updateAccount(AccountEntity account);
  Future<int> deleteAccount(int id);
}
