import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class AccountsListItemReadModel {
  final int accountId;
  final String identifier;
  final AccountProvider provider;
  final int totalServices;
  final int monthlyBill;
  final Currency currency;

  const AccountsListItemReadModel({
    required this.identifier,
    required this.provider,
    required this.totalServices,
    required this.monthlyBill,
    required this.currency,
    required this.accountId,
  });
}
