import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetServicesByAccount {
  final ServiceRepository repo;

  GetServicesByAccount(this.repo);

  Future<List<ServiceEntity>> call(int accountId) {
    return repo.getServicesByAccount(accountId);
  }
}
