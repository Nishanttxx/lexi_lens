import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class AppInput extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;

  const AppInput({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool _obscureText = true;
  bool _isHovered = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return FocusableActionDetector(
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visible Label — Never placeholder-only per DESIGN.md
          Text(
            widget.label,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTokens.space1),
          Container(
            constraints: const BoxConstraints(minHeight: AppTokens.minTouchTarget),
            decoration: BoxDecoration(
              borderRadius: AppTokens.borderRadiusSm,
              boxShadow: _isFocused ? AppTokens.shadow1 : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.enabled ? AppTokens.colorBgSurface : AppTokens.colorBgSurfaceMuted,
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppTokens.colorTextSecondary,
                          size: 20,
                        ),
                        tooltip: _obscureText ? 'Show password' : 'Hide password',
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space3,
                  vertical: AppTokens.space3,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppTokens.borderRadiusSm,
                  borderSide: BorderSide(
                    color: hasError
                        ? AppTokens.colorStateError
                        : (_isHovered ? AppTokens.colorBorderStrong : AppTokens.colorBorderDefault),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppTokens.borderRadiusSm,
                  borderSide: BorderSide(
                    color: hasError ? AppTokens.colorStateError : AppTokens.colorStateFocus,
                    width: 2.0,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: AppTokens.borderRadiusSm,
                  borderSide: BorderSide(color: AppTokens.colorStateError, width: 1.5),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: AppTokens.borderRadiusSm,
                  borderSide: BorderSide(color: AppTokens.colorStateError, width: 2.0),
                ),
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: AppTokens.space1),
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 14,
                  color: AppTokens.colorStateError,
                ),
                const SizedBox(width: AppTokens.space1),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(
                      color: AppTokens.colorStateError,
                      fontSize: AppTokens.fontSizeXs,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (widget.helperText != null) ...[
            const SizedBox(height: AppTokens.space1),
            Text(
              widget.helperText!,
              style: const TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeXs,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
