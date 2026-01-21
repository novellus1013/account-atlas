//vm - create account , update account

import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/create_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:account_atlas/features/accounts/domain/usecases/update_account.dart';
import 'package:account_atlas/features/accounts/presentation/provider/accounts_provider.dart';
import 'package:account_atlas/features/accounts/presentation/state/add_edit_account_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/account_detail_view_model.dart';
import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEditAccountViewModelProvider =
    NotifierProvider.family<AddEditAccountViewModel, AddEditAccountState, int?>(
      AddEditAccountViewModel.new,
    );

class AddEditAccountViewModel extends Notifier<AddEditAccountState> {
  final int? _accountId;

  AddEditAccountViewModel(this._accountId);

  CreateAccount get _createAccount => ref.watch(createAccountProvider);
  UpdateAccount get _updateAccount => ref.watch(updateAccountProvider);
  GetAccountById get _getAccountById => ref.watch(getAccountByIdProvider);

  @override
  AddEditAccountState build() {
    if (_accountId != null) {
      _load();
      return AddEditAccountLoading();
    }

    return const AddEditAccountLoaded(null);
  }

  Future<void> _load() async {
    state = const AddEditAccountLoading();

    try {
      final account = await _getAccountById.call(_accountId!);
      state = AddEditAccountLoaded(account);
    } on AccountFailure catch (e) {
      state = AddEditAccountError(e.message);
    } catch (e) {
      state = AddEditAccountError();
    }
  }

  Future<void> create(AccountEntity account) async {
    state = AddEditAccountSaving(account);

    try {
      final newId = await _createAccount.call(account);
      state = AddEditAccountLoaded(
        AccountEntity(
          id: newId,
          identifier: account.identifier,
          provider: account.provider,
          createdAt: account.createdAt,
        ),
      );
      ref.invalidate(accountsViewModelProvider);
    } on AccountFailure catch (e) {
      state = AddEditAccountError(e.message);
    } catch (e) {
      state = AddEditAccountError();
    }
  }

  Future<void> update(AccountEntity account) async {
    state = AddEditAccountSaving(account);

    try {
      await _updateAccount.call(account);
      state = AddEditAccountLoaded(account);
      ref.invalidate(accountsViewModelProvider);
      if (_accountId != null) {
        ref.invalidate(accountDetailViewModelProvider(_accountId));
      }
    } on AccountFailure catch (e) {
      state = AddEditAccountError(e.message);
    } catch (e) {
      state = AddEditAccountError();
    }
  }
}
