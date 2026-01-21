import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class GetAllServices {
  final ServiceRepository repo;

  GetAllServices(this.repo);

  Future<List<ServiceEntity>> call() {
    return repo.getAllServices();
  }
}
