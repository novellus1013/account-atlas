import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/usecases/get_all_services_detail.dart';
import 'package:account_atlas/features/services/presentation/state/services_state.dart';

class ServicesViewModel {
  final GetAllServicesDetail _getAllServicesDetail;

  ServicesViewModel(this._getAllServicesDetail);

  ServicesState _state = ServicesLoading();
  ServicesState get state => _state;

  Future<void> load() async {
    _state = ServicesLoading();
    try {
      final services = await _getAllServicesDetail.call();

      if (services.isEmpty) {
        _state = ServicesEmpty();
      } else {
        _state = ServicesLoaded(services);
      }
    } on ServiceFailure catch (e) {
      _state = ServicesError(e.message);
    } catch (e) {
      _state = ServicesError();
    }
  }
}
