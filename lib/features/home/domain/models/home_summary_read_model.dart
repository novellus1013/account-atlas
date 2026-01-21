import 'package:account_atlas/features/home/domain/models/category_spending_item.dart';
import 'package:account_atlas/features/home/domain/models/upcoming_payment_item.dart';

/// Read model containing all computed data for the HomeScreen.
class HomeSummaryReadModel {
  /// Sum of all monthly subscription amounts.
  final int monthlyTotalCost;

  /// Monthly total x 12.
  final int yearlyTotalCost;

  /// Count of services where isPay = true.
  final int subscriptionCount;

  /// Count of all services.
  final int totalServiceCount;

  /// Spending breakdown by category, sorted by percentage descending.
  final List<CategorySpendingItem> categorySpending;

  /// Services with D-day <= 7, sorted by nearest billing date.
  final List<UpcomingPaymentItem> upcomingPayments;

  const HomeSummaryReadModel({
    required this.monthlyTotalCost,
    required this.yearlyTotalCost,
    required this.subscriptionCount,
    required this.totalServiceCount,
    required this.categorySpending,
    required this.upcomingPayments,
  });

  /// Empty state for initial loading or when no data exists.
  static const empty = HomeSummaryReadModel(
    monthlyTotalCost: 0,
    yearlyTotalCost: 0,
    subscriptionCount: 0,
    totalServiceCount: 0,
    categorySpending: [],
    upcomingPayments: [],
  );
}
