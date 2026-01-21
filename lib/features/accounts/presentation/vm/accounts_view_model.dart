import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_all_accounts_detail.dart';
import 'package:account_atlas/features/accounts/presentation/provider/accounts_provider.dart';
import 'package:account_atlas/features/accounts/presentation/state/accounts_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountsViewModelProvider =
    NotifierProvider<AccountsViewModel, AccountsState>(AccountsViewModel.new);

class AccountsViewModel extends Notifier<AccountsState> {
  AccountsViewModel();

  GetAllAccountsDetail get _getAllAccountsDetail =>
      ref.watch(getAllAccountsDetailProvider);

  @override
  AccountsState build() {
    _load();
    return const AccountsLoading();
  }

  Future<void> _load() async {
    state = const AccountsLoading();

    try {
      final accounts = await _getAllAccountsDetail.call();

      if (accounts.isEmpty) {
        state = const AccountsEmpty();
      } else {
        state = AccountsLoaded(accounts);
      }
    } on AccountFailure catch (e) {
      state = AccountsError(e.message);
    } catch (e) {
      state = const AccountsError();
    }
  }
}
