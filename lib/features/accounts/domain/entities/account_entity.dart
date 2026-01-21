import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';

class AccountEntity {
  final int? id;
  final String identifier;
  final AccountProvider provider;
  //Domain 표현: 비지니스 의미를 가장 자연스럽게 담는 타입
  final DateTime? createdAt;

  AccountEntity({
    this.id,
    required this.identifier,
    required this.provider,
    this.createdAt,
  });
}
