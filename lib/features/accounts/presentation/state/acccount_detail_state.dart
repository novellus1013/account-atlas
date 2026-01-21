import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';

sealed class AccountDetailState {
  const AccountDetailState();
}

class AccountDetailLoading extends AccountDetailState {
  const AccountDetailLoading();
}

class AccountDetailError extends AccountDetailState {
  final String message;
  const AccountDetailError([this.message = 'An unknown error has occurred.']);
}

class AccountDetailLoaded extends AccountDetailState {
  final AccountDetailReadModel account;
  const AccountDetailLoaded(this.account);
}

class AccountDetailDeleted extends AccountDetailState {
  const AccountDetailDeleted();
}
