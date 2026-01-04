import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/delete_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_detail.dart';
import 'package:account_atlas/features/accounts/presentation/provider/accounts_provider.dart';
import 'package:account_atlas/features/accounts/presentation/state/acccount_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountDetailViewModelProvider =
    NotifierProvider.family<AccountDetailViewModel, AccountDetailState, int>(
      AccountDetailViewModel.new,
    );

class AccountDetailViewModel extends Notifier<AccountDetailState> {
  final int _accountId;

  AccountDetailViewModel(this._accountId);

  late final GetAccountDetail _getAccountDetail;
  late final DeleteAccount _deleteAccount;

  @override
  AccountDetailState build() {
    _getAccountDetail = ref.watch(getAccountDetailProvider);
    _deleteAccount = ref.watch(deleteAccountDetailProvider);

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

  Future<void> refresh() async => _load();

  Future<void> delete() async {
    try {
      await _deleteAccount.call(_accountId);
      state = const AccountDetailDeleted();
    } on AccountFailure catch (e) {
      state = AccountDetailError(e.message);
    } catch (e) {
      state = const AccountDetailError();
    }
  }
}
