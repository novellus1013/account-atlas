import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/services/domain/failure/plan_failure.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class DeleteAccountWithServices {
  final AccountRepository _accountRepo;
  final ServiceRepository _serviceRepo;
  final PlanRepository _planRepo;

  DeleteAccountWithServices(
    this._accountRepo,
    this._serviceRepo,
    this._planRepo,
  );

  Future<int> call(int accountId) async {
    final services = await _serviceRepo.getServicesByAccount(accountId);

    for (final service in services) {
      final serviceId = service.id;
      if (serviceId == null) continue;

      // Try to delete plan, but ignore if none exists (free services)
      try {
        await _planRepo.deletePlan(serviceId);
      } on PlanNotFound {
        // No plan exists - this is expected for free services
      }
      await _serviceRepo.deleteService(serviceId);
    }

    return await _accountRepo.deleteAccount(accountId);
  }
}
