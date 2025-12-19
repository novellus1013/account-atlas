import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

sealed class AddEditAccountState {
  const AddEditAccountState();
}

class AddEditAccountLoading extends AddEditAccountState {}

class AddEditAccountError extends AddEditAccountState {}

class AddEditAccountLoaded extends AddEditAccountState {
  //account가 존재하면 edit, 없으면 create
  final AccountEntity? account;
  const AddEditAccountLoaded(this.account);
}
