import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';

sealed class ServiceDetailState {
  const ServiceDetailState();
}

class ServiceDetailLoading extends ServiceDetailState {}

class ServiceDetailError extends ServiceDetailState {
  String message;
  ServiceDetailError([this.message = 'An unknown error has occurred.']);
}

class ServiceDetailLoaded extends ServiceDetailState {
  final ServiceDetailReadModel service;

  const ServiceDetailLoaded(this.service);
}
