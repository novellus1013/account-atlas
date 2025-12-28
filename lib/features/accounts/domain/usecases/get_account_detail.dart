import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetAccountDetail {
  final AccountRepository accountRepo;
  final ServiceRepository serviceRepo;

  GetAccountDetail(this.accountRepo, this.serviceRepo);

  Future<AccountDetailReadModel> call(int accountId) async {
    final account = await accountRepo.getAccountById(accountId);

    final services = await serviceRepo.getServicesByAccount(accountId);

    return AccountDetailReadModel(account, services);
  }
}
