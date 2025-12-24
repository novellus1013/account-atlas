import 'package:account_atlas/core/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const bool kIsProd = false;

void main() {
  runApp(ProviderScope(child: const App()));
  debugPrint("이것은 dev 버전 입니다");
}
