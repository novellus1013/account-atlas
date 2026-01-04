// import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
// import 'package:account_atlas/features/services/domain/entities/service_entity.dart';

// class AccountDetailReadModel {
//   final AccountEntity account;
//   final List<ServiceEntity?> services;

//   const AccountDetailReadModel(this.account, this.services);
// }

import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class AccountDetailReadModel {
  final AccountEntity account;

  /// 화면에서 바로 쓰기 좋게 분리해 둠
  final List<ServiceDetailReadModel> paidServices;
  final List<ServiceDetailReadModel> freeServices;

  /// 월 합계(월 기준 환산 포함)를 통화별로 제공
  /// (한 계정에서 통화가 여러 개면 UI에서 "Mixed"로 처리 가능)
  final Map<Currency, int> monthlyBillByCurrency;

  const AccountDetailReadModel({
    required this.account,
    required this.paidServices,
    required this.freeServices,
    required this.monthlyBillByCurrency,
  });

  int totalServiceCount() => paidServices.length + freeServices.length;
}

class ServiceDetailReadModel {
  final ServiceEntity service;
  final PlanEntity? plan;

  const ServiceDetailReadModel({required this.service, this.plan});

  bool get isPay => service.isPay;

  /// UI가 단순하게 쓰도록 대표값 제공
  int? get amount => plan?.amount;
  Currency? get currency => plan?.currency;
  DateTime? get nextBillingDate => plan?.nextBillingDate;
  BillingCycle? get billingCycle => plan?.billingCycle;

  String get displayName => service.displayName;

  /// 아이콘 매핑 키 (SimpleIcons 접근용)
  String? get iconKey => service.providedServiceKey;

  int? get serviceId => service.id;
}
