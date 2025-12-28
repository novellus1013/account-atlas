import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';

sealed class ServicesState {
  const ServicesState();
}

class ServicesLoading extends ServicesState {}

class ServicesEmpty extends ServicesState {}

class ServicesError extends ServicesState {
  String message;
  ServicesError([this.message = 'An unknown error has occurred.']);
}

class ServicesLoaded extends ServicesState {
  final List<ServiceDetailReadModel> services;

  const ServicesLoaded(this.services);
}
