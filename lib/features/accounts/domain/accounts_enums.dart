enum AccountProvider {
  email('Email'),
  phone('Phone'),
  google('Gmail'),
  apple('Apple'),
  github('Github'),
  facebook('Facebook'),
  whatsapp('Whatsapp'),
  others('Others');

  final String dbCode;

  const AccountProvider(this.dbCode);

  static AccountProvider fromDbcode(String code) {
    return AccountProvider.values.firstWhere(
      (e) => e.dbCode == code,
      orElse: () => AccountProvider.email,
    );
  }
}
