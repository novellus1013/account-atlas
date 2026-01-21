import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/delete_account_with_services.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_detail.dart';
import 'package:account_atlas/features/accounts/presentation/provider/accounts_provider.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountDetailViewModelProvider =
    NotifierProvider.family<AccountDetailViewModel, AccountDetailState, int>(
      AccountDetailViewModel.new,
    );

class AccountDetailViewModel extends Notifier<AccountDetailState> {
  final int _accountId;

  AccountDetailViewModel(this._accountId);

  GetAccountDetail get _getAccountDetail => ref.watch(getAccountDetailProvider);
  DeleteAccountWithServices get _deleteAccount =>
      ref.watch(deleteAccountDetailProvider);

  @override
  AccountDetailState build() {
    _load();

    return const AccountDetailLoading();
  }

  Future<void> _load() async {
    state = const AccountDetailLoading();

    try {
      final detail = await _getAccountDetail.call(_accountId);

      state = AccountDetailLoaded(detail);
    } on AccountFailure catch (e) {
      state = AccountDetailError(e.message);
    } catch (e) {
      state = const AccountDetailError();
    }
  }

  Future<void> delete() async {
    try {
      await _deleteAccount.call(_accountId);
      state = const AccountDetailDeleted();
      ref.invalidate(accountsViewModelProvider);
    } on AccountFailure catch (e) {
      state = AccountDetailError(e.message);
    } catch (e) {
      state = const AccountDetailError();
    }
  }
}
