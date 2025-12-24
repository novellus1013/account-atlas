import 'package:account_atlas/features/services/domain/services_enums.dart';

class ServiceEntity {
  final int? id;
  final int accountId;
  final String? providedServiceKey;
  final String displayName;
  final LoginType loginType;
  final String? loginId;
  final bool isPay;
  final String? memo;
  final DateTime? createdAt;

  ServiceEntity({
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
}
