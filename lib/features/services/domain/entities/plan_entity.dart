import 'package:account_atlas/features/services/domain/services_enums.dart';

class PlanEntity {
  final int? id;
  final int accountServiceId;
  final Currency currency;
  final int amount;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final DateTime? createdAt;

  PlanEntity({
    this.id,
    required this.accountServiceId,
    required this.currency,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    this.createdAt,
  });
}

//not null값인 accountServiceId 없이 Plan이 생성되는 경우를 방지하기 위해서
extension PlanEntityBinder on PlanEntity {
  PlanEntity bindToAccountService(int accountServiceId) {
    return PlanEntity(
      id: id,
      accountServiceId: accountServiceId,
      currency: currency,
      amount: amount,
      billingCycle: billingCycle,
      nextBillingDate: nextBillingDate,
      createdAt: createdAt,
    );
  }
}
