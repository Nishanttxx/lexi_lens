import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final String? semanticLabel;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isSelected = false,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.semanticLabel,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? AppTokens.borderRadiusMd;
    final isInteractive = widget.onTap != null;

    final media = MediaQuery.maybeOf(context);
    final reduceMotion = media?.disableAnimations ?? false;
    final animDuration = reduceMotion ? Duration.zero : AppTokens.durationFast;

    Border? effectiveBorder = widget.border;
    if (_isFocused) {
      effectiveBorder = Border.all(color: AppTokens.colorStateFocus, width: 2.0);
    } else if (widget.isSelected) {
      effectiveBorder = Border.all(color: AppTokens.colorAccentPrimary, width: 2.0);
    } else {
      effectiveBorder ??= Border.all(
        color: _isHovered && isInteractive
            ? AppTokens.colorBorderStrong
            : AppTokens.colorBorderDefault,
        width: 1.0,
      );
    }

    final cardContent = AnimatedContainer(
      duration: animDuration,
      padding: widget.padding ?? const EdgeInsets.all(AppTokens.space4),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppTokens.colorBgSurface,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
        boxShadow: _isHovered && isInteractive
            ? AppTokens.shadow2
            : AppTokens.shadow1,
      ),
      child: widget.child,
    );

    if (!isInteractive) {
      return Semantics(
        label: widget.semanticLabel,
        child: cardContent,
      );
    }

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: cardContent,
        ),
      ),
    );
  }
}
