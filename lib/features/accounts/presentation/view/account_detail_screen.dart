import 'package:flutter/material.dart';

class AccountDetailScreen extends StatelessWidget {
  final String id;

  const AccountDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('account_detail_screen $id'));
  }
}
