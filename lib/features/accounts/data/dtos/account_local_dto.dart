//DB_Schema와 동일하게 작성
class AccountLocalDto {
  final int? id;
  final String identifier;
  final String provider;
  final int? createdAt;

  AccountLocalDto({
    this.id,
    required this.identifier,
    required this.provider,
    this.createdAt,
  });

  factory AccountLocalDto.fromMap(Map<String, Object?> map) {
    return AccountLocalDto(
      id: map['id'] as int?,
      identifier: map['identifier'] as String,
      provider: map['provider'] as String,
      createdAt: map['created_at'] as int? ?? 0,
    );
  }

  Map<String, Object?> toInsertMap() {
    return {
      'identifier': identifier,
      'provider': provider,
      'created_at': createdAt,
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {'identifier': identifier, 'provider': provider};
  }
}
