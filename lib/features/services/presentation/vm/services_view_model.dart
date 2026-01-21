import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/usecases/get_all_services_detail.dart';
import 'package:account_atlas/features/services/presentation/provider/services_provider.dart';
import 'package:account_atlas/features/services/presentation/state/services_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesViewModelProvider =
    NotifierProvider<ServicesViewModel, ServicesState>(ServicesViewModel.new);

class ServicesViewModel extends Notifier<ServicesState> {
  ServicesViewModel();

  GetAllServicesDetail get _getAllServicesDetail =>
      ref.watch(getAllServicesDetail);

  @override
  ServicesState build() {
    _load();
    return const ServicesLoading();
  }

  Future<void> _load() async {
    state = const ServicesLoading();

    try {
      final services = await _getAllServicesDetail.call();

      if (services.isEmpty) {
        state = const ServicesEmpty();
      } else {
        state = ServicesLoaded(services);
      }
    } on ServiceFailure catch (e) {
      state = ServicesError(e.message);
    } catch (e) {
      state = ServicesError('Error: ${e.toString()}');
    }
  }

  Future<void> refresh() async {
    await _load();
  }
}
