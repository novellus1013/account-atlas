import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/usecases/delete_service.dart';
import 'package:account_atlas/features/services/domain/usecases/get_service_detail_by_id.dart';
import 'package:account_atlas/features/services/presentation/state/service_detail_state.dart';

class ServiceDetailViewModel {
  final GetServiceDetailById _getServiceDetail;
  final DeleteService _deleteService;

  ServiceDetailViewModel(this._getServiceDetail, this._deleteService);

  ServiceDetailState _state = ServiceDetailLoading();
  ServiceDetailState get state => _state;

  Future<void> load(int serviceId) async {
    _state = ServiceDetailLoading();

    try {
      final service = await _getServiceDetail.call(serviceId);

      _state = ServiceDetailLoaded(service);
    } on ServiceFailure catch (e) {
      _state = ServiceDetailError(e.message);
    } catch (e) {
      _state = ServiceDetailError();
    }
  }

  Future<void> delete(int serviceId) async {
    try {
      await _deleteService.call(serviceId);
    } on ServiceFailure catch (e) {
      _state = ServiceDetailError(e.message);
    } catch (e) {
      _state = ServiceDetailError();
    }
  }
}
