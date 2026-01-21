import 'package:account_atlas/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:account_atlas/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/services/data/datasources/plan_local_datasource.dart';
import 'package:account_atlas/features/services/data/datasources/service_local_datasource.dart';
import 'package:account_atlas/features/services/data/repositories/plan_repository_impl.dart';
import 'package:account_atlas/features/services/data/repositories/service_repository_impl.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
import 'package:account_atlas/features/services/domain/usecases/delete_service.dart';
import 'package:account_atlas/features/services/domain/usecases/get_all_services_detail.dart';
import 'package:account_atlas/features/services/domain/usecases/get_service_detail_by_id.dart';
import 'package:account_atlas/features/services/domain/usecases/save_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountLocalDatasourceProvider = Provider<AccountLocalDatasource>((ref) {
  return AccountLocalDatasource();
});

final serviceLocalDatasourceProvider = Provider<ServiceLocalDatasource>((ref) {
  return ServiceLocalDatasource();
});

final planLocalDatasourceProvider = Provider<PlanLocalDatasource>((ref) {
  return PlanLocalDatasource();
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(ref.watch(accountLocalDatasourceProvider));
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepositoryImpl(ref.watch(serviceLocalDatasourceProvider));
});

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl(ref.watch(planLocalDatasourceProvider));
});

final deleteServiceProvider = Provider<DeleteService>((ref) {
  return DeleteService(
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final saveServiceProvider = Provider<SaveService>((ref) {
  return SaveService(
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final getServiceDetailByIdProvider = Provider<GetServiceDetailById>((ref) {
  return GetServiceDetailById(
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final getAllServicesDetail = Provider<GetAllServicesDetail>((ref) {
  return GetAllServicesDetail(
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});
