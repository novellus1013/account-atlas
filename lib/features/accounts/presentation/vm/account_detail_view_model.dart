import 'package:account_atlas/features/accounts/domain/usecases/delete_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';

class AccountDetailViewModel {
  final GetAccountById _getAccountById;
  final DeleteAccount _deleteAccount;

  AccountDetailViewModel(this._getAccountById, this._deleteAccount);

  AccountDetailState _state = AccountDetailLoading();
  AccountDetailState get state => _state;

  Future<void> load(int id) async {
    _state = AccountDetailLoading();

    try {
      final account = await _getAccountById.call(id);

      if (account == null) {
        _state = AccountDetailError();
      } else {
        _state = AccountDetailLoaded(account);
      }
    } catch (e) {
      _state = AccountDetailError();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _deleteAccount.call(id);
    } catch (e) {
      _state = AccountDetailError();
    }
  }
}
