import 'package:account_atlas/features/home/domain/models/home_summary_read_model.dart';

sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}

class HomeError extends HomeState {
  final String message;
  const HomeError([this.message = 'Failed to load home data.']);
}

class HomeLoaded extends HomeState {
  final HomeSummaryReadModel summary;
  const HomeLoaded(this.summary);
}
