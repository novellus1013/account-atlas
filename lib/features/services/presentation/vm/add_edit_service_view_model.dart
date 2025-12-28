import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/usecases/get_service_detail_by_id.dart';
import 'package:account_atlas/features/services/domain/usecases/save_service.dart';
import 'package:account_atlas/features/services/presentation/state/add_edit_service_state.dart';

class AddEditServiceViewModel {
  final SaveService _saveService;
  final GetServiceDetailById _getServiceDetailById;

  AddEditServiceViewModel(this._saveService, this._getServiceDetailById);

  AddEditServiceState _state = AddEditServiceLoading();
  AddEditServiceState get state => _state;

  Future<void> load(int serviceId) async {
    _state = AddEditServiceLoading();

    try {
      final service = await _getServiceDetailById(serviceId);
      _state = AddEditServiceLoaded(service);
    } on ServiceFailure catch (e) {
      _state = AddEditServiceError(e.message);
    } catch (e) {
      _state = AddEditServiceError();
    }
  }

  Future<void> save(ServiceDetailReadModel service) async {
    try {
      await _saveService.call(service);
      _state = AddEditServiceLoaded(service);
    } on ServiceFailure catch (e) {
      _state = AddEditServiceError(e.message);
    } catch (e) {
      _state = AddEditServiceError();
    }
  }
}
