import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_button.dart';

class GuestBanner extends StatefulWidget {
  final VoidCallback onLogin;

  const GuestBanner({super.key, required this.onLogin});

  @override
  State<GuestBanner> createState() => _GuestBannerState();
}

class _GuestBannerState extends State<GuestBanner> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.space4,
        vertical: AppTokens.space2,
      ),
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurfaceMuted,
        border: const Border(
          bottom: BorderSide(color: AppTokens.colorBorderDefault, width: 1.0),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppTokens.colorAccentPrimary,
                size: 20,
              ),
              const SizedBox(width: AppTokens.space2),
              const Expanded(
                child: Text(
                  'Guest session: You can scan, read, and listen freely. To save documents and custom typography defaults to your library, sign in.',
                  style: TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: AppTokens.space3),
              AppButton(
                text: 'Sign in',
                variant: AppButtonVariant.primary,
                onPressed: widget.onLogin,
              ),
              const SizedBox(width: AppTokens.space1),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: AppTokens.colorTextSecondary),
                onPressed: () => setState(() => _isDismissed = true),
                tooltip: 'Dismiss notice',
                constraints: const BoxConstraints(
                  minWidth: AppTokens.minTouchTarget,
                  minHeight: AppTokens.minTouchTarget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
