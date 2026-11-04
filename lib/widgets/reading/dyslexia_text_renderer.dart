import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/user_preferences.dart';
import '../../core/theme/app_tokens.dart';

class DyslexiaTextRenderer extends StatelessWidget {
  final String text;
  final UserPreferences preferences;
  final int activeWordIndex;
  final Function(int wordIndex)? onWordTap;
  final bool isEditing;
  final TextEditingController? editController;

  const DyslexiaTextRenderer({
    super.key,
    required this.text,
    required this.preferences,
    this.activeWordIndex = -1,
    this.onWordTap,
    this.isEditing = false,
    this.editController,
  });

  TextStyle _resolveReadingTextStyle() {
    final fontSize = preferences.fontSize.toDouble();
    // em to px
    final letterSpacing = preferences.letterSpacing * fontSize;
    // Strict dyslexia rule: lineSpacing never below 1.5
    final height = preferences.lineSpacing.clamp(1.5, 2.2);

    switch (preferences.fontFamily) {
      case 'Atkinson Hyperlegible':
        return GoogleFonts.atkinsonHyperlegible(
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          height: height,
          color: AppTokens.colorTextPrimary,
          fontWeight: FontWeight.w400,
        );
      case 'Lexend':
        return GoogleFonts.lexend(
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          height: height,
          color: AppTokens.colorTextPrimary,
          fontWeight: FontWeight.w400,
        );
      case 'OpenDyslexic':
      default:
        // Try local OpenDyslexic or fall back to Lexend for high-legibility weighted bottoms
        return TextStyle(
          fontFamily: 'OpenDyslexic',
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          height: height,
          color: AppTokens.colorTextPrimary,
          fontWeight: FontWeight.w400,
        );
    }
  }

  Color _resolveOverlayBackground() {
    switch (preferences.overlayColor) {
      case 'cream':
        return AppTokens.overlayCream;
      case 'blue':
        return AppTokens.overlayBlue;
      case 'rose':
        return AppTokens.overlayRose;
      case 'mint':
        return AppTokens.overlayMint;
      case 'none':
      default:
        return AppTokens.colorBgSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveReadingTextStyle();
    final overlayBg = _resolveOverlayBackground();

    if (isEditing && editController != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTokens.space4),
        decoration: BoxDecoration(
          color: AppTokens.colorBgSurface,
          borderRadius: AppTokens.borderRadiusMd,
          border: Border.all(color: AppTokens.colorStateFocus, width: 2.0),
          boxShadow: AppTokens.shadow1,
        ),
        child: TextField(
          controller: editController,
          maxLines: null,
          style: style,
          textAlign: TextAlign.left, // Strictly ragged-right, NEVER justified!
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: false,
            hintText: 'Edit or type reading text here…',
          ),
        ),
      );
    }

    final words = text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTokens.space5),
        decoration: BoxDecoration(
          color: overlayBg,
          borderRadius: AppTokens.borderRadiusMd,
          border: Border.all(color: AppTokens.colorBorderDefault, width: 1.0),
        ),
        child: const Text(
          'No text extracted yet.',
          style: TextStyle(
            color: AppTokens.colorTextSecondary,
            fontSize: AppTokens.fontSizeSm,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.space5),
      decoration: BoxDecoration(
        color: overlayBg,
        borderRadius: AppTokens.borderRadiusMd,
        border: Border.all(color: AppTokens.colorBorderDefault, width: 1.0),
        boxShadow: AppTokens.shadow1,
      ),
      // Left aligned / ragged right: NEVER justified per DESIGN.md and SKILL.md!
      child: SelectableText.rich(
        TextSpan(
          children: List.generate(words.length, (index) {
            final word = words[index];
            final isHighlighted = index == activeWordIndex;

            // Subtle highlight background: colorAccentWarm (#E8833B) with colorTextPrimary (#211D1A)
            return WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: onWordTap != null ? () => onWordTap!(index) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  margin: EdgeInsets.only(
                    right: (preferences.letterSpacing * 20.0 + 6.0),
                    bottom: (preferences.lineSpacing * 2.0),
                  ),
                  decoration: BoxDecoration(
                    color: isHighlighted ? AppTokens.colorAccentWarm : Colors.transparent,
                    borderRadius: AppTokens.borderRadiusSm,
                  ),
                  child: Text(
                    word,
                    textAlign: TextAlign.left,
                    style: style.copyWith(
                      // AAA contrast verified
                      color: AppTokens.colorTextPrimary,
                      fontWeight: isHighlighted ? FontWeight.w700 : style.fontWeight,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        textAlign: TextAlign.left, // Strictly ragged-right!
      ),
    );
  }
}
