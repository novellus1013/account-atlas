import 'package:account_atlas/features/services/data/datasources/service_local_datasource.dart';
import 'package:account_atlas/features/services/data/mappers/service_local_mapper.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/failure/service_failure.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDatasource local;

  ServiceRepositoryImpl(this.local);

  @override
  Future<int> insertService(ServiceEntity entity) {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      final dto = entity.toInsertDto(now);

      return local.insertService(dto);
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }

  @override
  Future<ServiceEntity?> getServiceById(int id) async {
    try {
      final dto = await local.getServiceById(id);
      if (dto == null) {
        throw ServiceNotFound();
      }

      return dto.toEntity();
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }

  @override
  Future<List<ServiceEntity>> getServicesByAccount(int accountId) async {
    try {
      final dtos = await local.getServicesByAccount(accountId);
      final entites = dtos.map((e) => e.toEntity()).toList();

      return entites;
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }

  @override
  Future<List<ServiceEntity>> getAllServices() async {
    try {
      final dtos = await local.getAllServices();
      final entites = dtos.map((e) => e.toEntity()).toList();

      return entites;
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }

  @override
  Future<int> updateService(ServiceEntity entity) async {
    try {
      final dto = entity.toUpdateDto();

      final result = await local.updateService(dto);

      if (result == 0) {
        throw ServiceNotFound();
      } else {
        return result;
      }
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }

  @override
  Future<int> deleteService(int id) async {
    try {
      final result = await local.deleteService(id);

      if (result == 0) {
        throw ServiceNotFound();
      } else {
        return result;
      }
    } on ServiceFailure {
      rethrow;
    } catch (e) {
      throw ServiceStorageFailure();
    }
  }
}
