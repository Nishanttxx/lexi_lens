import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import 'app_button.dart';

class ErrorBanner extends StatelessWidget {
  final String title;
  final String message;
  final String? retryText;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    super.key,
    this.title = 'Unable to Process Image',
    required this.message,
    this.retryText = 'Try Again',
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: '$title. $message',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppTokens.space2),
        padding: const EdgeInsets.all(AppTokens.space4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBECE9),
          borderRadius: AppTokens.borderRadiusMd,
          border: Border.all(color: AppTokens.colorStateError, width: 1.5),
          boxShadow: AppTokens.shadow1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppTokens.colorStateError,
                  size: 24,
                ),
                const SizedBox(width: AppTokens.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppTokens.colorStateError,
                          fontSize: AppTokens.fontSizeMd,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppTokens.space1),
                      Text(
                        message,
                        style: const TextStyle(
                          color: AppTokens.colorTextPrimary,
                          fontSize: AppTokens.fontSizeSm,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppTokens.colorTextSecondary),
                    onPressed: onDismiss,
                    tooltip: 'Dismiss error message',
                  ),
              ],
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTokens.space3),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  text: retryText ?? 'Try Again',
                  icon: Icons.refresh_rounded,
                  variant: AppButtonVariant.primary,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
