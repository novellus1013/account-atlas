import 'package:account_atlas/features/home/domain/usecases/get_home_summary.dart';
import 'package:account_atlas/features/home/presentation/provider/home_provider.dart';
import 'package:account_atlas/features/home/presentation/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);

class HomeViewModel extends Notifier<HomeState> {
  HomeViewModel();

  GetHomeSummary get _getHomeSummary => ref.watch(getHomeSummaryProvider);

  @override
  HomeState build() {
    _load();
    return const HomeLoading();
  }

  Future<void> _load() async {
    state = const HomeLoading();

    try {
      final summary = await _getHomeSummary.call();

      if (summary.totalServiceCount == 0) {
        state = const HomeEmpty();
      } else {
        state = HomeLoaded(summary);
      }
    } catch (e) {
      state = HomeError('Error: ${e.toString()}');
    }
  }

  Future<void> refresh() async {
    await _load();
  }
}
