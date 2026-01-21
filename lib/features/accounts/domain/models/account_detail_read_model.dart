import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

class AccountDetailReadModel {
  final AccountEntity account;

  final List<ServiceDetailReadModel> paidServices;
  final List<ServiceDetailReadModel> freeServices;

  /// 월 합계
  final int monthlyBillByCurrency;

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

  int? get amount => plan?.amount;
  Currency? get currency => plan?.currency;
  DateTime? get nextBillingDate => plan?.nextBillingDate;
  BillingCycle? get billingCycle => plan?.billingCycle;

  String get displayName => service.displayName;

  String? get iconKey => service.providedServiceKey;

  int? get serviceId => service.id;
}
