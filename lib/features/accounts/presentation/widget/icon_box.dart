import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;

  const IconBox({
    super.key,
    required this.color,
    required this.icon,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}
