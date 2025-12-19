class AccountEntity {
  final int? id;
  final String identifier;
  final String provider;
  //Domain 표현: 비지니스 의미를 가장 자연스럽게 담는 타입
  final DateTime? createdAt;

  AccountEntity({
    this.id,
    required this.identifier,
    required this.provider,
    this.createdAt,
  });
}
