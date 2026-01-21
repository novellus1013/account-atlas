import 'package:account_atlas/features/home/domain/usecases/get_home_summary.dart';
import 'package:account_atlas/features/services/domain/usecases/get_all_services_detail.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/services/presentation/provider/services_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getHomeSummaryProvider = Provider<GetHomeSummary>((ref) {
  final getAllServicesDetail = GetAllServicesDetail(
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
  final catalogRepo = ref.watch(serviceCatalogRepositoryProvider);

  return GetHomeSummary(getAllServicesDetail, catalogRepo);
});
