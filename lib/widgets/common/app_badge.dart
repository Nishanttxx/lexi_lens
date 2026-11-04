import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppTokens.colorBgSurfaceMuted;
    final fg = textColor ?? AppTokens.colorTextSecondary;
    final border = borderColor ?? AppTokens.colorBorderDefault;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space2,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppTokens.borderRadiusPill,
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: AppTokens.fontSizeXs,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
