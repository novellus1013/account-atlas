sealed class ServiceFailure implements Exception {
  final String message;
  const ServiceFailure(this.message);
}

class ServiceNotFound extends ServiceFailure {
  const ServiceNotFound() : super('Service not found');
}

class ServiceStorageFailure extends ServiceFailure {
  const ServiceStorageFailure()
    : super('Failed to access local storage("services")');
}
