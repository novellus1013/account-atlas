import 'package:flutter/material.dart';

class PolicyWebViewScreen extends StatelessWidget {
  final String url;

  const PolicyWebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('policy_web_view_screen'));
  }
}
