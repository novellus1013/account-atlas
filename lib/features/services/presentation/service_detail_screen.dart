import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String id;

  const ServiceDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('service_detail_screen'));
  }
}
