import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

enum AppButtonVariant { primary, secondary, destructive, ghost, outline }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final String? disabledReason;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.focusNode,
    this.semanticLabel,
    this.disabledReason,
  });

  // Alias for backward compatibility if any screen used 'danger'
  static const AppButtonVariant danger = AppButtonVariant.destructive;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  Color _getBackgroundColor() {
    if (_isDisabled) {
      if (widget.variant == AppButtonVariant.primary || widget.variant == AppButtonVariant.destructive) {
        return AppTokens.colorBorderStrong.withValues(alpha: 0.35);
      }
      return Colors.transparent;
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
        if (_isPressed) return AppTokens.colorAccentPrimaryHover;
        if (_isHovered) return AppTokens.colorAccentPrimaryHover;
        return AppTokens.colorAccentPrimary;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
        if (_isPressed) return AppTokens.colorBgSurfaceMuted;
        if (_isHovered) return AppTokens.colorBgSurfaceMuted.withValues(alpha: 0.7);
        return Colors.transparent;
      case AppButtonVariant.destructive:
        if (_isPressed) return AppTokens.colorStateError.withValues(alpha: 0.85);
        if (_isHovered) return const Color(0xFF9E3622);
        return AppTokens.colorStateError;
      case AppButtonVariant.ghost:
        if (_isPressed) return AppTokens.colorBgSurfaceMuted;
        if (_isHovered) return AppTokens.colorBgSurfaceMuted.withValues(alpha: 0.6);
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (_isDisabled) {
      return AppTokens.colorTextSecondary.withValues(alpha: 0.45);
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.destructive:
        return AppTokens.colorTextInverse;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
        return _isHovered ? AppTokens.colorTextPrimary : AppTokens.colorTextPrimary;
      case AppButtonVariant.ghost:
        return AppTokens.colorAccentPrimary;
    }
  }

  Border? _getBorder() {
    if (_isFocused) {
      return Border.all(color: AppTokens.colorStateFocus, width: 2.0);
    }
    if (widget.variant == AppButtonVariant.secondary || widget.variant == AppButtonVariant.outline) {
      return Border.all(
        color: _isDisabled
            ? AppTokens.colorBorderDefault.withValues(alpha: 0.5)
            : (_isHovered ? AppTokens.colorBorderStrong : AppTokens.colorBorderStrong),
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _getBackgroundColor();
    final fg = _getTextColor();
    final border = _getBorder();

    // Respect reduced motion setting
    final media = MediaQuery.maybeOf(context);
    final reduceMotion = media?.disableAnimations ?? false;
    final animDuration = reduceMotion ? Duration.zero : AppTokens.durationInstant;

    Widget buttonContent = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: AppTokens.space2),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: fg),
          const SizedBox(width: AppTokens.space2),
        ],
        // Never truncate button label — wrap to 2 lines if space is tight per DESIGN.md
        Flexible(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: fg,
              fontSize: AppTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ],
    );

    final semanticText = widget.disabledReason != null
        ? '${widget.semanticLabel ?? widget.text}. Disabled: ${widget.disabledReason}'
        : (widget.semanticLabel ?? widget.text);

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: semanticText,
      liveRegion: widget.isLoading,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        enabled: !_isDisabled,
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: _isDisabled ? null : (_) => setState(() => _isPressed = true),
          onTapUp: _isDisabled ? null : (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: _isDisabled ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: animDuration,
            // Ensure minimum 44x44px touch target throughout
            constraints: BoxConstraints(
              minHeight: AppTokens.minTouchTarget,
              minWidth: widget.isFullWidth ? double.infinity : AppTokens.minTouchTarget,
            ),
            width: widget.isFullWidth ? double.infinity : widget.width,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space4,
              vertical: AppTokens.space2,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AppTokens.borderRadiusSm,
              border: border,
              boxShadow: _isHovered && !_isDisabled ? AppTokens.shadow2 : AppTokens.shadow1,
            ),
            child: Center(
              widthFactor: widget.isFullWidth ? null : 1.0,
              heightFactor: 1.0,
              child: buttonContent,
            ),
          ),
        ),
      ),
    );
  }
}
