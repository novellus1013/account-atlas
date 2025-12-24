class PlanLocalDto {
  final int? id;
  final int accountServiceId;
  final String currency;
  final int amount;
  final int billingCycle;
  final int nextBillingDate;
  final int? createdAt;

  PlanLocalDto({
    this.id,
    required this.accountServiceId,
    required this.currency,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    this.createdAt,
  });

  factory PlanLocalDto.fromMap(Map<String, Object?> map) {
    return PlanLocalDto(
      id: map['id'] as int?,
      accountServiceId: map['account_service_id'] as int,
      currency: map['currency'] as String,
      amount: map['amount'] as int,
      billingCycle: map['billing_cycle'] as int,
      nextBillingDate: map['next_billing_date'] as int,
      createdAt: map['created_at'] as int?,
    );
  }

  Map<String, Object?> toInsertMap() {
    return {
      'account_service_id': accountServiceId,
      'currency': currency,
      'amount': amount,
      'billing_cycle': billingCycle,
      'next_billing_date': nextBillingDate,
      'created_at': createdAt,
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {
      'currency': currency,
      'amount': amount,
      'billing_cycle': billingCycle,
      'next_billing_date': nextBillingDate,
    };
  }
}
