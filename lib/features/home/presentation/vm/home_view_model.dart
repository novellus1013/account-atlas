import 'package:account_atlas/features/analystics/domain/usecases/get_category_spending.dart';
import 'package:account_atlas/features/analystics/domain/usecases/get_monthy_yearly_spending.dart';
import 'package:account_atlas/features/analystics/domain/usecases/get_upcoming_spending.dart';
import 'package:account_atlas/features/home/presentation/state/home_state.dart';

class HomeViewModel {
  final GetCategorySpending _getCategorySpending;
  final GetMonthyYearlySpending _getMonthyYearlySpending;
  final GetUpcomingSpending _getUpcomingSpending;

  HomeViewModel(
    this._getCategorySpending,
    this._getMonthyYearlySpending,
    this._getUpcomingSpending,
  );

  HomeState _state = HomeLoading();
  HomeState get state => _state;

  Future<void> load() async {
    _state = HomeLoading();
    try {
      final categories = await _getCategorySpending.call();
      final monthlyYearly = await _getMonthyYearlySpending.call();
      final upcomings = await _getUpcomingSpending.call();

      _state = HomeLoaded(categories, monthlyYearly, upcomings);
    } catch (e) {
      _state = HomeError();
    }
  }
}
