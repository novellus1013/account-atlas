class EnvConfig {
  static late EnvConfig _instance;

  final bool isProd;
  final bool enableMockData;
  final String appName;

  EnvConfig._({
    required this.isProd,
    required this.enableMockData,
    required this.appName,
  });

  static void init({required bool isProd, bool? enableMockData}) {
    _instance = EnvConfig._(
      isProd: isProd,
      enableMockData: enableMockData ?? !isProd,
      appName: isProd ? 'Account Atlas' : 'Account Atlas (Dev)',
    );
  }

  static EnvConfig get instance => _instance;

  static bool get isProduction => _instance.isProd;

  static bool get isDevelopment => !_instance.isProd;
}
