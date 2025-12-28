import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';

sealed class AddEditServiceState {
  const AddEditServiceState();
}

class AddEditServiceLoading extends AddEditServiceState {}

class AddEditServiceError extends AddEditServiceState {
  String message;
  AddEditServiceError([this.message = 'An unknown error has occurred.']);
}

class AddEditServiceLoaded extends AddEditServiceState {
  //service가 존재하면 edit, 없으면 create
  final ServiceDetailReadModel service;

  const AddEditServiceLoaded(this.service);
}
