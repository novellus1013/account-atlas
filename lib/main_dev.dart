import 'package:account_atlas/core/app/app.dart';
import 'package:account_atlas/core/storage/mock_data_seeder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const bool kIsProd = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockDataSeeder.seedIfEmpty();
  runApp(ProviderScope(child: const App()));
  debugPrint("이것은 dev 버전 입니다");
}
