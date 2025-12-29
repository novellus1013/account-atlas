enum Currency {
  ko('KRW'),
  en('USD');

  final String dbCode;

  const Currency(this.dbCode);

  static Currency fromDbCode(String code) {
    return Currency.values.firstWhere(
      (e) => e.dbCode == code,
      orElse: () => Currency.en,
    );
  }
}

enum BillingCycle {
  monthly(0),
  yearly(1);

  final int dbNumb;

  const BillingCycle(this.dbNumb);

  static BillingCycle fromDbCode(int number) {
    return BillingCycle.values.firstWhere(
      (e) => e.dbNumb == number,
      orElse: () => BillingCycle.monthly,
    );
  }
}

//enhanced enum
enum LoginType {
  id('ID'),
  social('SOCIAL'),
  phone('PHONE');

  final String dbCode;

  const LoginType(this.dbCode);

  static LoginType fromDbCode(String code) {
    return LoginType.values.firstWhere(
      (e) => e.dbCode == code,
      orElse: () => LoginType.social,
    );
  }
}

enum ServiceCategory {
  video('Video'),
  music('Music'),
  shopping('Shopping'),
  tool('Tool'),
  sns('Sns'),
  ai('AI'),
  game('Game'),
  education('Edu'),
  others('Others');

  final String dbCode;

  const ServiceCategory(this.dbCode);

  static ServiceCategory fromDbcode(String code) {
    return ServiceCategory.values.firstWhere(
      (e) => e.dbCode == code,
      orElse: () => ServiceCategory.others,
    );
  }
}
