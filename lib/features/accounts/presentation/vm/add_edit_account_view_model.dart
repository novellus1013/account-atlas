//vm - create account , update account

import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/create_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:account_atlas/features/accounts/domain/usecases/update_account.dart';
import 'package:account_atlas/features/accounts/presentation/state/add_edit_account_state.dart';

class AddEditAccountViewModel {
  final CreateAccount _createAccount;
  final UpdateAccount _updateAccount;
  final GetAccountById _getAccountById;

  AddEditAccountViewModel(
    this._createAccount,
    this._updateAccount,
    this._getAccountById,
  );

  AddEditAccountState _state = AddEditAccountLoading();
  AddEditAccountState get state => _state;

  Future<void> load(int accountId) async {
    _state = AddEditAccountLoading();

    try {
      final account = await _getAccountById.call(accountId);
      _state = AddEditAccountLoaded(account);
    } on AccountFailure catch (e) {
      _state = AddEditAccountError(e.message);
    } catch (e) {
      _state = AddEditAccountError();
    }
  }

  Future<void> create(AccountEntity account) async {
    try {
      await _createAccount.call(account);
      _state = AddEditAccountLoaded(account);
    } on AccountFailure catch (e) {
      _state = AddEditAccountError(e.message);
    } catch (e) {
      _state = AddEditAccountError();
    }
  }

  Future<void> update(AccountEntity account) async {
    try {
      await _updateAccount.call(account);
      _state = AddEditAccountLoaded(account);
    } on AccountFailure catch (e) {
      _state = AddEditAccountError(e.message);
    } catch (e) {
      _state = AddEditAccountError();
    }
  }
}
