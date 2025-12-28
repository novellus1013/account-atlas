import 'package:account_atlas/features/accounts/domain/entities/account_detail_read_model.dart';

sealed class AccountDetailState {
  const AccountDetailState();
}

class AccountDetailLoading extends AccountDetailState {}

class AccountDetailError extends AccountDetailState {}

class AccountDetailLoaded extends AccountDetailState {
  final AccountDetailReadModel account;
  const AccountDetailLoaded(this.account);
}
