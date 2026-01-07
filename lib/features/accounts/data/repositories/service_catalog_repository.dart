import 'dart:convert';

import 'package:flutter/services.dart';

class ServiceCatalogRepository {
  Future<Map<String, ServiceCatalogItem>> loadCatalog() async {
    final raw = await rootBundle.loadString('assets/data/service_catalog.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final categories = data['categories'] as List<dynamic>? ?? [];
    final Map<String, ServiceCatalogItem> catalog = {};

    for (final category in categories) {
      final map = category as Map<String, dynamic>;
      final services = map['services'] as List<dynamic>? ?? [];
      for (final service in services) {
        final item = ServiceCatalogItem.fromJson(
          service as Map<String, dynamic>,
        );
        catalog[item.key] = item;
      }
    }

    return catalog;
  }
}

class ServiceCatalogItem {
  final String key;
  final String displayName;
  final String category;
  final String? iconKey;
  final int? iconColor;

  const ServiceCatalogItem({
    required this.key,
    required this.displayName,
    required this.category,
    required this.iconKey,
    required this.iconColor,
  });

  factory ServiceCatalogItem.fromJson(Map<String, dynamic> json) {
    final iconColor = json['iconColor'] as String?;
    return ServiceCatalogItem(
      key: json['key'] as String,
      displayName: json['displayName'] as String,
      category: json['category'] as String,
      iconKey: json['iconKey'] as String?,
      iconColor: iconColor != null ? _parseHexColor(iconColor) : null,
    );
  }

  static int _parseHexColor(String value) {
    final normalized = value.startsWith('0x')
        ? value.replaceFirst('0x', '')
        : value;
    return int.parse(normalized, radix: 16);
  }
}
