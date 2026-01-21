import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:flutter/material.dart';

/// A widget to display error states with retry functionality.
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorStateWidget({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSpacing.icon64,
              color: Colors.red.shade400,
            ),
            Gaps.v16,
            Text(
              title,
              style: TextStyle(
                fontSize: AppTextSizes.lg,
                fontWeight: FontWeight.w600,
                color: AppColor.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.v8,
            Text(
              message,
              style: TextStyle(
                fontSize: AppTextSizes.md,
                color: AppColor.grey500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              Gaps.v24,
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget to display empty states with optional action button.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.icon64,
              color: AppColor.grey400,
            ),
            Gaps.v16,
            Text(
              title,
              style: const TextStyle(
                fontSize: AppTextSizes.lg,
                fontWeight: FontWeight.w600,
                color: AppColor.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              Gaps.v8,
              Text(
                message!,
                style: const TextStyle(
                  fontSize: AppTextSizes.md,
                  color: AppColor.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              Gaps.v24,
              ElevatedButton.icon(
                onPressed: onAction,
                icon: actionIcon != null
                    ? Icon(actionIcon, size: AppSpacing.iconMd)
                    : const SizedBox.shrink(),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A simple loading widget centered on screen.
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColor.primary),
          if (message != null) ...[
            Gaps.v16,
            Text(
              message!,
              style: const TextStyle(
                fontSize: AppTextSizes.md,
                color: AppColor.grey500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
