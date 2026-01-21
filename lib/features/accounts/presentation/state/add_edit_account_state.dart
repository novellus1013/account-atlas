import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

sealed class AddEditAccountState {
  const AddEditAccountState();
}

class AddEditAccountLoading extends AddEditAccountState {
  const AddEditAccountLoading();
}

class AddEditAccountSaving extends AddEditAccountState {
  final AccountEntity? account;
  const AddEditAccountSaving([this.account]);
}

class AddEditAccountError extends AddEditAccountState {
  final String message;
  const AddEditAccountError([this.message = 'An unknown error has occurred.']);
}

class AddEditAccountLoaded extends AddEditAccountState {
  //account가 존재하면 edit, 없으면 create
  final AccountEntity? account;
  const AddEditAccountLoaded(this.account);
}
