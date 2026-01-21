import 'package:account_atlas/features/services/domain/services_enums.dart';

class UpcomingSpendingEntity {
  final ServiceCategory category;
  final String title;
  final DateTime nextBiilingDate;
  final int amount;

  UpcomingSpendingEntity(
    this.category,
    this.title,
    this.nextBiilingDate,
    this.amount,
  );
}
