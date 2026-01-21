import 'package:account_atlas/core/app/app.dart';
import 'package:account_atlas/core/config/env_config.dart';
import 'package:account_atlas/core/storage/mock_data_seeder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Run commands:  flutter run --dart-define=ENV=prod  vs  flutter run --dart-define=ENV=dev

const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');
// const String _env = String.fromEnvironment('ENV', defaultValue: 'prod');

const bool _isProd = _env == 'prod';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig.init(isProd: _isProd);

  if (EnvConfig.instance.enableMockData) {
    await MockDataSeeder.seedIfEmpty();
  }

  runApp(const ProviderScope(child: App()));
}
