import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

sealed class AccountDetailState {
  const AccountDetailState();
}

class AccountDetailLoading extends AccountDetailState {}

class AccountDetailError extends AccountDetailState {}

class AccountDetailLoaded extends AccountDetailState {
  final AccountEntity account;
  const AccountDetailLoaded(this.account);
}
