class ServiceLocalDto {
  final int? id;
  final int accountId;
  final String? providedServiceKey;
  final String displayName;
  final String loginType;
  final String? loginId;
  final int isPay;
  final String? memo;
  final int? createdAt;

  ServiceLocalDto({
    this.id,
    required this.accountId,
    this.providedServiceKey,
    required this.displayName,
    required this.loginType,
    this.loginId,
    required this.isPay,
    this.memo,
    this.createdAt,
  });

  factory ServiceLocalDto.fromMap(Map<String, Object?> map) {
    return ServiceLocalDto(
      id: map['id'] as int?,
      accountId: map['account_id'] as int,
      providedServiceKey: map['provided_service_key'] as String?,
      displayName: map['display_name'] as String,
      loginType: map['login_type'] as String,
      loginId: map['login_id'] as String?,
      isPay: map['is_pay'] as int,
      memo: map['memo'] as String?,
      createdAt: map['created_at'] as int?,
    );
  }

  Map<String, Object?> toInsertMap() {
    return {
      'account_id': accountId,
      'provided_service_key': providedServiceKey,
      'display_name': displayName,
      'login_type': loginType,
      'login_id': loginId,
      'is_pay': isPay,
      'memo': memo,
      'created_at': createdAt,
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {
      'account_id': accountId,
      'provided_service_key': providedServiceKey,
      'display_name': displayName,
      'login_type': loginType,
      'login_id': loginId,
      'is_pay': isPay,
      'memo': memo,
    };
  }
}
