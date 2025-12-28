import 'package:account_atlas/features/accounts/domain/usecases/delete_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_detail.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';

class AccountDetailViewModel {
  final GetAccountDetail _getAccountDetail;
  final DeleteAccount _deleteAccount;

  AccountDetailViewModel(this._getAccountDetail, this._deleteAccount);

  AccountDetailState _state = AccountDetailLoading();
  AccountDetailState get state => _state;

  Future<void> load(int accountId) async {
    _state = AccountDetailLoading();

    try {
      final detail = await _getAccountDetail.call(accountId);

      if (detail == null) {
        _state = AccountDetailError();
      } else {
        _state = AccountDetailLoaded(detail);
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
