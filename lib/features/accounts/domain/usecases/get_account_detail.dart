// import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';
// import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
// import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

// class GetAccountDetail {
//   final AccountRepository accountRepo;
//   final ServiceRepository serviceRepo;

//   GetAccountDetail(this.accountRepo, this.serviceRepo);

//   Future<AccountDetailReadModel> call(int accountId) async {
//     final account = await accountRepo.getAccountById(accountId);

//     final services = await serviceRepo.getServicesByAccount(accountId);

//     return AccountDetailReadModel(account, services);
//   }
// }

import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/domain/models/account_detail_read_model.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class GetAccountDetail {
  final AccountRepository _accountRepo;
  final ServiceRepository _serviceRepo;
  final PlanRepository _planRepo;

  GetAccountDetail(this._accountRepo, this._serviceRepo, this._planRepo);

  Future<AccountDetailReadModel> call(int accountId) async {
    final AccountEntity account = await _accountRepo.getAccountById(accountId);

    final List<ServiceEntity> services = await _serviceRepo
        .getServicesByAccount(accountId);

    final List<ServiceDetailReadModel> paid = [];
    final List<ServiceDetailReadModel> free = [];

    int monthlyBillByCurrency = 0;

    for (final service in services) {
      final serviceId = service.id;

      if (serviceId == null) {
        continue;
      }

      final PlanEntity plan = await _planRepo.getPlanByAccountServiceId(
        serviceId,
      );

      final rm = ServiceDetailReadModel(service: service, plan: plan);

      if (service.isPay) {
        paid.add(rm);

        // 월 합계 계산: billingCycle에 따라 월 기준 환산
        final p = plan;
        final monthly = _toMonthlyAmount(p.amount, p.billingCycle);
        monthlyBillByCurrency += monthly;
      } else {
        free.add(rm);
      }
    }

    return AccountDetailReadModel(
      account: account,
      paidServices: paid,
      freeServices: free,
      monthlyBillByCurrency: monthlyBillByCurrency,
    );
  }

  int _toMonthlyAmount(int amount, BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.yearly:
        // 단순 환산(필요하면 반올림 정책 정하기)
        return (amount / 12).round();
    }
  }
}
