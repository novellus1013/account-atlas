import 'package:account_atlas/features/analystics/domain/entities/category_spending_entity.dart';
import 'package:account_atlas/features/analystics/domain/entities/monthly_yearly_spending_entity.dart';
import 'package:account_atlas/features/analystics/domain/entities/upcoming_spending_entity.dart';

sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategorySpendingEntity> categories;
  final MonthlyYearlySpendingEntity monthlyYearly;
  final List<UpcomingSpendingEntity> upcomings;
  const HomeLoaded(this.categories, this.monthlyYearly, this.upcomings);
}
