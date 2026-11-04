import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTokens.colorBgSurfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
                boxShadow: AppTokens.shadow1,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppTokens.colorAccentPrimary,
              ),
            ),
            const SizedBox(height: AppTokens.space3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeXl,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.space2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeSm,
                  height: 1.5,
                ),
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppTokens.space4),
              AppButton(
                text: actionText!,
                icon: actionIcon,
                variant: AppButtonVariant.primary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
