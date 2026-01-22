import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:account_atlas/features/home/presentation/vm/home_view_model.dart';
import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/usecases/delete_service.dart';
import 'package:account_atlas/features/services/domain/usecases/get_service_detail_by_id.dart';
import 'package:account_atlas/features/services/presentation/provider/services_provider.dart';
import 'package:account_atlas/features/services/presentation/state/service_detail_state.dart';
import 'package:account_atlas/features/services/presentation/vm/services_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceDetailViewmodelProvider =
    NotifierProvider.family<ServiceDetailViewModel, ServiceDetailState, int>(
      ServiceDetailViewModel.new,
    );

class ServiceDetailViewModel extends Notifier<ServiceDetailState> {
  final int _accountServiceId;

  ServiceDetailViewModel(this._accountServiceId);

  GetServiceDetailById get _getServiceDetailById =>
      ref.watch(getServiceDetailByIdProvider);
  DeleteService get _deleteService => ref.watch(deleteServiceProvider);

  @override
  ServiceDetailState build() {
    _load();

    return const ServiceDetailLoading();
  }

  Future<void> _load() async {
    state = ServiceDetailLoading();

    try {
      final service = await _getServiceDetailById.call(_accountServiceId);

      state = ServiceDetailLoaded(service);
    } on ServiceFailure catch (e) {
      state = ServiceDetailError(e.message);
    } catch (e) {
      state = ServiceDetailError();
    }
  }

  Future<void> delete(int serviceId) async {
    try {
      await _deleteService.call(serviceId);
      state = const ServiceDetailDeleted();
      ref.invalidate(servicesViewModelProvider);
      ref.invalidate(accountsViewModelProvider);
      ref.invalidate(homeViewModelProvider);
    } on ServiceFailure catch (e) {
      state = ServiceDetailError(e.message);
    } catch (e) {
      state = ServiceDetailError();
    }
  }
}
