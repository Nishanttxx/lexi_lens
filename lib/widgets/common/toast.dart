import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: isError ? AppTokens.colorStateError : AppTokens.colorStateSuccess,
              size: 20,
            ),
            const SizedBox(width: AppTokens.space3),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFFBECE9) : const Color(0xFFEAF5EF),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusSm,
          side: BorderSide(
            color: isError ? AppTokens.colorStateError : AppTokens.colorStateSuccess,
            width: 1.5,
          ),
        ),
        margin: const EdgeInsets.all(AppTokens.space3),
      ),
    );
  }
}
