import 'package:account_atlas/features/accounts/presentation/vm/account_detail_view_model.dart';
import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:account_atlas/features/home/presentation/vm/home_view_model.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/usecases/get_service_detail_by_id.dart';
import 'package:account_atlas/features/services/domain/usecases/save_service.dart';
import 'package:account_atlas/features/services/presentation/provider/services_provider.dart';
import 'package:account_atlas/features/services/presentation/state/add_edit_service_state.dart';
import 'package:account_atlas/features/services/presentation/vm/services_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEditserviceViewModelProvider =
    NotifierProvider.family<AddEditServiceViewModel, AddEditServiceState, int?>(
      AddEditServiceViewModel.new,
    );

class AddEditServiceViewModel extends Notifier<AddEditServiceState> {
  final int? _accountServiceId;

  AddEditServiceViewModel(this._accountServiceId);

  SaveService get _saveService => ref.watch(saveServiceProvider);
  GetServiceDetailById get _getServiceDetailById =>
      ref.watch(getServiceDetailByIdProvider);

  @override
  AddEditServiceState build() {
    if (_accountServiceId != null) {
      _load();
      return const AddEditServiceLoading();
    }

    return const AddEditServiceLoaded(null);
  }

  Future<void> _load() async {
    state = const AddEditServiceLoading();

    try {
      final service = await _getServiceDetailById.call(_accountServiceId!);
      state = AddEditServiceLoaded(service);
    } on ServiceFailure catch (e) {
      state = AddEditServiceError(e.message);
    } catch (e) {
      state = AddEditServiceError();
    }
  }

  Future<void> create(ServiceDetailReadModel model) async {
    state = AddEditServiceSaving(model);

    try {
      final newServiceId = await _saveService.call(model);

      final updatedService = ServiceEntity(
        id: newServiceId,
        accountId: model.service.accountId,
        providedServiceKey: model.service.providedServiceKey,
        displayName: model.service.displayName,
        loginType: model.service.loginType,
        loginId: model.service.loginId,
        category: model.service.category,
        isPay: model.service.isPay,
        memo: model.service.memo,
        createdAt: model.service.createdAt,
      );

      final updatedPlan = model.plan != null
          ? PlanEntity(
              id: null,
              accountServiceId: newServiceId,
              currency: model.plan!.currency,
              amount: model.plan!.amount,
              billingCycle: model.plan!.billingCycle,
              nextBillingDate: model.plan!.nextBillingDate,
              createdAt: model.plan!.createdAt,
            )
          : null;

      // Invalidate providers to refresh lists and counts
      ref.invalidate(servicesViewModelProvider);
      ref.invalidate(homeViewModelProvider);
      ref.invalidate(accountsViewModelProvider);
      ref.invalidate(accountDetailViewModelProvider(model.service.accountId));

      state = AddEditServiceLoaded(
        ServiceDetailReadModel(service: updatedService, plan: updatedPlan),
      );
    } on ServiceFailure catch (e) {
      state = AddEditServiceError(e.message);
    } catch (e) {
      state = AddEditServiceError();
    }
  }

  Future<void> update(ServiceDetailReadModel model) async {
    state = AddEditServiceSaving(model);

    try {
      await _saveService.call(model);

      // Invalidate providers to refresh lists and counts
      ref.invalidate(servicesViewModelProvider);
      ref.invalidate(homeViewModelProvider);
      ref.invalidate(accountsViewModelProvider);
      ref.invalidate(accountDetailViewModelProvider(model.service.accountId));

      state = AddEditServiceLoaded(model);
    } on ServiceFailure catch (e) {
      state = AddEditServiceError(e.message);
    } catch (e) {
      state = AddEditServiceError();
    }
  }
}
