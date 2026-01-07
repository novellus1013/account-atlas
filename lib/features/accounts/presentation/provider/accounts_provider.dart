import 'package:account_atlas/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:account_atlas/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:account_atlas/features/accounts/domain/repositories/account_repository.dart';
import 'package:account_atlas/features/accounts/domain/usecases/create_account.dart';
import 'package:account_atlas/features/accounts/domain/usecases/delete_account_with_services.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_by_id.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_account_detail.dart';
import 'package:account_atlas/features/accounts/domain/usecases/get_all_accounts_detail.dart';
import 'package:account_atlas/features/accounts/domain/usecases/update_account.dart';
import 'package:account_atlas/features/services/data/datasources/plan_local_datasource.dart';
import 'package:account_atlas/features/services/data/datasources/service_local_datasource.dart';
import 'package:account_atlas/features/services/data/repositories/plan_repository_impl.dart';
import 'package:account_atlas/features/services/data/repositories/service_repository_impl.dart';
import 'package:account_atlas/features/services/domain/repositories/plan_repository.dart';
import 'package:account_atlas/features/services/domain/repositories/service_repository.dart';
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

final getAllAccountsDetailProvider = Provider<GetAllAccountsDetail>((ref) {
  return GetAllAccountsDetail(
    ref.watch(accountRepositoryProvider),
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final getAccountDetailProvider = Provider<GetAccountDetail>((ref) {
  return GetAccountDetail(
    ref.watch(accountRepositoryProvider),
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final deleteAccountDetailProvider = Provider<DeleteAccountWithServices>((ref) {
  return DeleteAccountWithServices(
    ref.watch(accountRepositoryProvider),
    ref.watch(serviceRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final createAccountProvider = Provider<CreateAccount>((ref) {
  return CreateAccount(ref.watch(accountRepositoryProvider));
});

final updateAccountProvider = Provider<UpdateAccount>((ref) {
  return UpdateAccount(ref.watch(accountRepositoryProvider));
});

final getAccountByIdProvider = Provider<GetAccountById>((ref) {
  return GetAccountById(ref.watch(accountRepositoryProvider));
});
