import 'package:account_atlas/core/utils/billing_calculator.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/home/domain/models/category_spending_item.dart';
import 'package:account_atlas/features/home/domain/models/home_summary_read_model.dart';
import 'package:account_atlas/features/home/domain/models/upcoming_payment_item.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/domain/usecases/get_all_services_detail.dart';

/// Usecase that fetches and computes all home screen summary data.
class GetHomeSummary {
  final GetAllServicesDetail _getAllServicesDetail;
  final ServiceCatalogRepository _catalogRepo;

  GetHomeSummary(this._getAllServicesDetail, this._catalogRepo);

  Future<HomeSummaryReadModel> call() async {
    // Fetch all services and catalog
    final services = await _getAllServicesDetail.call();
    final catalog = await _catalogRepo.loadCatalog();

    if (services.isEmpty) {
      return HomeSummaryReadModel.empty;
    }

    // Calculate counts
    final totalServiceCount = services.length;
    final subscriptionCount = services.where((s) => s.service.isPay).length;

    // Calculate monthly total (convert yearly to monthly)
    final monthlyTotalCost = _calculateMonthlyTotal(services);
    final yearlyTotalCost = monthlyTotalCost * 12;

    // Calculate category spending
    final categorySpending = _calculateCategorySpending(
      services,
      monthlyTotalCost,
    );

    // Calculate upcoming payments (D-day <= 7)
    final upcomingPayments = _calculateUpcomingPayments(services, catalog);

    return HomeSummaryReadModel(
      monthlyTotalCost: monthlyTotalCost,
      yearlyTotalCost: yearlyTotalCost,
      subscriptionCount: subscriptionCount,
      totalServiceCount: totalServiceCount,
      categorySpending: categorySpending,
      upcomingPayments: upcomingPayments,
    );
  }

  /// Calculates total monthly cost from all subscription services.
  /// Converts yearly billing to monthly equivalent.
  int _calculateMonthlyTotal(List<ServiceDetailReadModel> services) {
    int total = 0;
    for (final service in services) {
      if (service.service.isPay && service.plan != null) {
        final plan = service.plan!;
        if (plan.billingCycle == BillingCycle.yearly) {
          total += (plan.amount / 12).round();
        } else {
          total += plan.amount;
        }
      }
    }
    return total;
  }

  /// Groups services by category and calculates spending percentages.
  /// Returns list sorted by percentage descending.
  List<CategorySpendingItem> _calculateCategorySpending(
    List<ServiceDetailReadModel> services,
    int monthlyTotalCost,
  ) {
    if (monthlyTotalCost == 0) return [];

    // Group by category
    final categoryAmounts = <ServiceCategory, int>{};
    for (final service in services) {
      if (service.service.isPay && service.plan != null) {
        final category = service.service.category;
        final plan = service.plan!;
        final monthlyAmount = plan.billingCycle == BillingCycle.yearly
            ? (plan.amount / 12).round()
            : plan.amount;

        categoryAmounts[category] =
            (categoryAmounts[category] ?? 0) + monthlyAmount;
      }
    }

    // Convert to list with percentages
    final items = categoryAmounts.entries.map((entry) {
      final percentage = (entry.value / monthlyTotalCost) * 100;
      return CategorySpendingItem(
        category: entry.key,
        monthlyAmount: entry.value,
        percentage: percentage,
      );
    }).toList();

    // Sort by percentage descending
    items.sort((a, b) => b.percentage.compareTo(a.percentage));

    return items;
  }

  /// Filters services with D-day <= 7 and sorts by nearest billing date.
  List<UpcomingPaymentItem> _calculateUpcomingPayments(
    List<ServiceDetailReadModel> services,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    final items = <UpcomingPaymentItem>[];

    for (final service in services) {
      if (!service.service.isPay || service.plan == null) continue;

      final serviceId = service.service.id;
      if (serviceId == null) continue;

      final plan = service.plan!;
      final dDay = BillingCalculator.calculateDDay(plan.nextBillingDate);

      // Only include if D-day <= 7
      if (dDay > 7) continue;

      final billingDate = BillingCalculator.computeNextBillingDate(
        plan.nextBillingDate,
      );

      // Get catalog info for icon
      final catalogKey = service.service.providedServiceKey;
      final catalogItem = catalogKey != null ? catalog[catalogKey] : null;

      items.add(
        UpcomingPaymentItem(
          serviceId: serviceId,
          serviceName: service.service.displayName,
          iconKey: catalogItem?.iconKey,
          iconColor: catalogItem?.iconColor,
          category: service.service.category,
          billingDate: billingDate,
          amount: plan.amount,
          dDay: dDay,
        ),
      );
    }

    // Sort by D-day ascending (nearest first)
    items.sort((a, b) => a.dDay.compareTo(b.dDay));

    return items;
  }
}
