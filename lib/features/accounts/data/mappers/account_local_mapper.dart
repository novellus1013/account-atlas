import 'package:account_atlas/features/accounts/data/dtos/account_local_dto.dart';
import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';

extension AccountLocalDtoMapper on AccountLocalDto {
  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      identifier: identifier,
      provider: provider,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt!),
    );
  }
}

extension AccountEntityMapper on AccountEntity {
  AccountLocalDto toInsertDto(int now) {
    return AccountLocalDto(
      identifier: identifier,
      provider: provider,
      createdAt: now,
    );
  }

  AccountLocalDto toUpdateDto() {
    return AccountLocalDto(id: id, identifier: identifier, provider: provider);
  }
}
