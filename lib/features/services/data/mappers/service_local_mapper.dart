import 'package:account_atlas/features/services/data/dtos/service_local_dto.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';

extension ServiceLocalDtoMapper on ServiceLocalDto {
  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      accountId: accountId,
      providedServiceKey: providedServiceKey,
      displayName: displayName,
      loginType: LoginType.fromDbCode(loginType),
      loginId: loginId,
      category: ServiceCategory.fromDbcode(category),
      isPay: isPay == 0 ? false : true,
      memo: memo,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt!),
    );
  }
}

extension ServiceEntityMapper on ServiceEntity {
  ServiceLocalDto toInsertDto(int now) {
    return ServiceLocalDto(
      accountId: accountId,
      displayName: displayName,
      providedServiceKey: providedServiceKey,
      loginType: loginType.dbCode,
      loginId: loginId,
      category: category.dbCode,
      isPay: isPay == false ? 0 : 1,
      memo: memo,
      createdAt: now,
    );
  }

  ServiceLocalDto toUpdateDto() {
    return ServiceLocalDto(
      id: id,
      accountId: accountId,
      displayName: displayName,
      providedServiceKey: providedServiceKey,
      loginType: loginType.dbCode,
      loginId: loginId,
      category: category.dbCode,
      isPay: isPay == false ? 0 : 1,
      memo: memo,
    );
  }
}
