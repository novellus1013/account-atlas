sealed class PlanFailure implements Exception {
  final String message;
  const PlanFailure(this.message);
}

class PlanNotFound extends PlanFailure {
  const PlanNotFound() : super('Plan not found');
}

class PlanStorageFailure extends PlanFailure {
  const PlanStorageFailure() : super('Failed to access local storage("plans")');
}
