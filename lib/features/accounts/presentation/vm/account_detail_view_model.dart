import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
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

      _state = AccountDetailLoaded(detail);
    } on AccountFailure catch (e) {
      _state = AccountDetailError(e.message);
    } catch (e) {
      _state = AccountDetailError();
    }
  }

  Future<void> delete(int accountId) async {
    try {
      await _deleteAccount.call(accountId);
    } on AccountFailure catch (e) {
      _state = AccountDetailError(e.message);
    } catch (e) {
      _state = AccountDetailError();
    }
  }
}
