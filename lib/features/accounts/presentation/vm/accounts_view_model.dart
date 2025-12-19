import 'package:account_atlas/features/accounts/domain/usecases/get_all_accounts.dart';
import 'package:account_atlas/features/accounts/presentation/state/accounts_state.dart';

class AccountsViewModel {
  final GetAllAccounts _getAllAccounts;

  AccountsViewModel(this._getAllAccounts);

  AccountsState _state = AccountsLoading();
  AccountsState get state => _state;

  Future<void> load() async {
    _state = AccountsLoading();
    try {
      final accounts = await _getAllAccounts.call();

      if (accounts.isEmpty) {
        _state = AccountsEmpty();
      } else {
        _state = AccountsLoaded(accounts);
      }
    } catch (e) {
      _state = AccountsError();
    }
  }
}
