import 'package:account_atlas/features/services/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<int> insertService(ServiceEntity service);
  Future<ServiceEntity> getServiceById(int id);
  Future<List<ServiceEntity>> getServicesByAccount(int accountId);
  Future<List<ServiceEntity>> getAllServices();
  Future<int> updateService(ServiceEntity service);
  Future<int> deleteService(int id);
}
