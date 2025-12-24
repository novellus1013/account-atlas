import 'package:account_atlas/features/services/data/dtos/plan_local_dto.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

extension PlanLocalDtoMapper on PlanLocalDto {
  PlanEntity toEntity() {
    return PlanEntity(
      id: id,
      accountServiceId: accountServiceId,
      currency: Currency.fromDbCode(currency),
      amount: amount,
      billingCycle: BillingCycle.fromDbCode(billingCycle),
      nextBillingDate: DateTime.fromMillisecondsSinceEpoch(nextBillingDate),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt!),
    );
  }
}

extension PlanEntityMapper on PlanEntity {
  PlanLocalDto toInsertDto(int now) {
    return PlanLocalDto(
      accountServiceId: accountServiceId,
      currency: currency.dbCode,
      amount: amount,
      billingCycle: billingCycle.dbNumb,
      nextBillingDate: nextBillingDate.millisecondsSinceEpoch,
      createdAt: now,
    );
  }

  PlanLocalDto toUpdateDto() {
    return PlanLocalDto(
      id: id,
      accountServiceId: accountServiceId,
      currency: currency.dbCode,
      amount: amount,
      billingCycle: billingCycle.dbNumb,
      nextBillingDate: nextBillingDate.millisecondsSinceEpoch,
    );
  }
}
