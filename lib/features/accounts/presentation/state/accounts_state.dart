import 'package:account_atlas/features/accounts/domain/models/accounts_list_item_read_model.dart';

sealed class AccountsState {
  const AccountsState();
}

class AccountsLoading extends AccountsState {
  const AccountsLoading();
}

class AccountsError extends AccountsState {
  final String message;
  const AccountsError([this.message = 'An unknown error has occurred.']);
}

class AccountsEmpty extends AccountsState {
  const AccountsEmpty();
}

class AccountsLoaded extends AccountsState {
  final List<AccountsListItemReadModel> accounts;
  const AccountsLoaded(this.accounts);
}
