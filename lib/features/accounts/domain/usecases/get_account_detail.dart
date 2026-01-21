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
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
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

      if (service.isPay) {
        // Only fetch plan for paid services
        PlanEntity? plan;
        try {
          plan = await _planRepo.getPlanByAccountServiceId(serviceId);
        } on PlanNotFound {
          // Paid service without a plan yet - treat as no plan
          plan = null;
        }

        final rm = ServiceDetailReadModel(service: service, plan: plan);
        paid.add(rm);

        // Calculate monthly bill if plan exists
        if (plan != null) {
          final monthly = _toMonthlyAmount(plan.amount, plan.billingCycle);
          monthlyBillByCurrency += monthly;
        }
      } else {
        // Free service - no plan needed
        final rm = ServiceDetailReadModel(service: service, plan: null);
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
