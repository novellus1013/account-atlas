import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:flutter/material.dart';

/// A bottom action bar with Edit and Delete buttons.
/// Used in detail screens for consistent action UI.
class ActionButtonsBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String editLabel;
  final String deleteLabel;
  final IconData editIcon;
  final IconData deleteIcon;

  const ActionButtonsBar({
    super.key,
    required this.onEdit,
    required this.onDelete,
    this.editLabel = 'Edit',
    this.deleteLabel = 'Delete',
    this.editIcon = Icons.edit,
    this.deleteIcon = Icons.delete_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.basic),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Edit Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: Icon(editIcon, size: AppSpacing.iconMd),
              label: Text(editLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.basic),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
          Gaps.h12,
          // Delete Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: Icon(deleteIcon, size: AppSpacing.iconMd),
              label: Text(deleteLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.error,
                side: const BorderSide(color: AppColor.error, width: 2),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.basic),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
