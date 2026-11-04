import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import 'app_button.dart';

class LoadingIndicator extends StatefulWidget {
  final String status;
  final String? subtitle;
  final VoidCallback? onCancel;
  final double? progress; // 0.0 to 1.0 or null for indeterminate

  const LoadingIndicator({
    super.key,
    required this.status,
    this.subtitle,
    this.onCancel,
    this.progress,
  });

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final reduceMotion = media?.disableAnimations ?? false;

    return Semantics(
      liveRegion: true,
      label: '${widget.status}. ${widget.subtitle ?? ""}',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (!reduceMotion)
                    RotationTransition(
                      turns: _controller,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTokens.colorAccentPrimary.withValues(alpha: 0.15),
                            width: 3.5,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: CircularProgressIndicator(
                      value: widget.progress,
                      strokeWidth: 3.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTokens.colorAccentPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.document_scanner_rounded,
                    color: AppTokens.colorAccentPrimary,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: AppTokens.space4),
              Text(
                widget.status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSizeLg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: AppTokens.space1),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTokens.colorTextSecondary,
                      fontSize: AppTokens.fontSizeSm,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              if (widget.onCancel != null) ...[
                const SizedBox(height: AppTokens.space4),
                AppButton(
                  text: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  icon: Icons.close_rounded,
                  onPressed: widget.onCancel,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
