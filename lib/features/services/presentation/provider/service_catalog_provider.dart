import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceCatalogRepositoryProvider = Provider<ServiceCatalogRepository>((
  ref,
) {
  return ServiceCatalogRepository();
});

final serviceCatalogProvider = FutureProvider<Map<String, ServiceCatalogItem>>((
  ref,
) {
  return ref.watch(serviceCatalogRepositoryProvider).loadCatalog();
});
