import 'package:account_atlas/features/services/domain/services_enums.dart';

/// Represents an upcoming payment within the next 7 days.
class UpcomingPaymentItem {
  final int serviceId;
  final String serviceName;
  final String? iconKey;
  final int? iconColor;
  final ServiceCategory category;
  final DateTime billingDate;
  final int amount;
  final int dDay;

  const UpcomingPaymentItem({
    required this.serviceId,
    required this.serviceName,
    this.iconKey,
    this.iconColor,
    required this.category,
    required this.billingDate,
    required this.amount,
    required this.dDay,
  });
}
