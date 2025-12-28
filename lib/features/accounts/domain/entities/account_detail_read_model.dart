import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';

class AccountDetailReadModel {
  final AccountEntity account;
  final List<ServiceEntity> services;

  const AccountDetailReadModel(this.account, this.services);
}
