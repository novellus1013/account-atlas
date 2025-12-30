import 'package:account_atlas/features/accounts/domain/models/accounts_list_item_read_model.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class GetAllAccountsDetail {
  final AccountRepository _accountRepo;
  final ServiceRepository _serviceRepo;
  final PlanRepository _planRepo;

  GetAllAccountsDetail(this._accountRepo, this._serviceRepo, this._planRepo);

  Future<List<AccountsListItemReadModel>> call() async {
    final accounts = await _accountRepo.getAllAccounts();

    final List<AccountsListItemReadModel> result = [];

    for (final account in accounts) {
      final accountId = account.id;
      if (accountId == null) continue;

      final services = await _serviceRepo.getServicesByAccount(accountId);

      if (services.isEmpty) {
        result.add(
          AccountsListItemReadModel(
            accountId: accountId,
            identifier: account.identifier,
            provider: account.provider,
            totalServices: 0,
            monthlyBill: 0,
            currency: Currency.en,
          ),
        );
      }

      int monthlyBill = 0;

      for (final service in services) {
        final plan = await _planRepo.getPlanByAccountServiceId(service.id!);
        monthlyBill += plan.amount;
      }

      result.add(
        AccountsListItemReadModel(
          accountId: accountId,
          identifier: account.identifier,
          provider: account.provider,
          totalServices: services.length,
          monthlyBill: monthlyBill,
          currency: Currency.en,
        ),
      );
    }

    return result;
  }
}
