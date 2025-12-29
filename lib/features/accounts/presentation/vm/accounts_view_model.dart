import 'package:account_atlas/features/accounts/domain/failure/account_failure.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_all_accounts_detail.dart';
import 'package:account_atlas/features/accounts/presentation/state/accounts_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccountsViewModel extends StateNotifier<AccountsState> {
  final GetAllAccountsDetail _getAllAccountsDetail;

  AccountsViewModel(this._getAllAccountsDetail)
    : super(const AccountsLoading()) {
    load();
  }

  Future<void> load() async {
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
