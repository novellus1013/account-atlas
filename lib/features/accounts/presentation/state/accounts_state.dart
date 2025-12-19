import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

sealed class AccountsState {
  const AccountsState();
}

class AccountsLoading extends AccountsState {}

class AccountsError extends AccountsState {}

class AccountsEmpty extends AccountsState {}

class AccountsLoaded extends AccountsState {
  final List<AccountEntity> accounts;
  const AccountsLoaded(this.accounts);
}
