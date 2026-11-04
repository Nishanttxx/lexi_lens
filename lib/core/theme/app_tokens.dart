import 'package:flutter/material.dart';

/// Centralized Design System Tokens for Lexi Lens
/// Strictly derived from DESIGN.md and SKILL.md.
class AppTokens {
  AppTokens._();

  // ==========================================
  // Color Palette (Warm, Low-Glare, High-Legibility)
  // ==========================================
  /// App canvas background — warm ivory, not stark white (#FBF6EE)
  static const Color colorBgCanvas = Color(0xFFFBF6EE);

  /// Cards, modals, and content panels sitting on canvas (#FFFFFF)
  static const Color colorBgSurface = Color(0xFFFFFFFF);

  /// Secondary panels, input backgrounds, navigation chrome (#F1E9DA)
  static const Color colorBgSurfaceMuted = Color(0xFFF1E9DA);

  /// Soft warm charcoal for primary text — not pure black (#211D1A)
  /// Contrast: 7:1 or higher (AAA) against canvas and every overlay tint.
  static const Color colorTextPrimary = Color(0xFF211D1A);

  /// Secondary / helper text (#5B5349)
  static const Color colorTextSecondary = Color(0xFF5B5349);

  /// Inverted text for filled primary accent surfaces (#FBF6EE)
  static const Color colorTextInverse = Color(0xFFFBF6EE);

  /// Primary deep moss teal for primary actions and links (#2B6E63)
  static const Color colorAccentPrimary = Color(0xFF2B6E63);

  /// Primary hover/active shade (#235A51)
  static const Color colorAccentPrimaryHover = Color(0xFF235A51);

  /// Warm amber reserved exclusively for TTS "currently reading" highlight and active audio (#E8833B)
  static const Color colorAccentWarm = Color(0xFFE8833B);

  /// Default subtle borders and dividers (#DCD2C0)
  static const Color colorBorderDefault = Color(0xFFDCD2C0);

  /// Stronger borders for emphasis and resting input focus (#B8AA8E)
  static const Color colorBorderStrong = Color(0xFFB8AA8E);

  /// Focus ring indicator — deliberately different hue from accent so focus is never ambiguous (#1D4E8F)
  static const Color colorStateFocus = Color(0xFF1D4E8F);

  /// Success state confirmations (#2F7A4D)
  static const Color colorStateSuccess = Color(0xFF2F7A4D);

  /// Error state — always paired with text and icon, never color alone (#B3412B)
  static const Color colorStateError = Color(0xFFB3412B);

  // Backward compatibility aliases if needed
  static const Color colorBackground = colorBgCanvas;
  static const Color colorSurface = colorBgSurface;
  static const Color colorSurfaceMuted = colorBgSurfaceMuted;
  static const Color colorSurfaceCard = colorBgSurface;
  static const Color colorSurfaceElevated = colorBgSurfaceMuted;
  static const Color colorTextTertiary = colorTextSecondary;
  static const Color colorBorder = colorBorderDefault;
  static const Color colorFocus = colorStateFocus;
  static const Color colorError = colorStateError;
  static const Color colorSuccess = colorStateSuccess;
  static const double radiusXs = radiusSm;

  // ==========================================
  // Reading Overlay Tints (User Selectable)
  // Contrast rule: colorTextPrimary on each overlay >= 7:1 AAA
  // ==========================================
  static const Color overlayNone = Colors.transparent;
  static const Color overlayCream = Color(0xFFFFF6D9);
  static const Color overlayBlue = Color(0xFFE4F0F6);
  static const Color overlayRose = Color(0xFFFBE7E4);
  static const Color overlayMint = Color(0xFFE4F3EA);

  // ==========================================
  // Typography Scale (UI Chrome)
  // Fixed font family: Atkinson Hyperlegible
  // ==========================================
  static const double fontSizeXs = 13.0; // Helper text, timestamps
  static const double fontSizeSm = 15.0; // Secondary labels, form inputs
  static const double fontSizeMd = 17.0; // Base UI text, body copy in chrome
  static const double fontSizeLg = 19.0; // Emphasized UI text
  static const double fontSizeXl = 22.0; // Section headings
  static const double fontSize2xl = 26.0; // Page titles
  static const double fontSize3xl = 32.0; // Landing hero
  static const double fontSize4xl = 40.0; // Landing hero (large viewport)

  static const double lineHeightUi = 1.4;
  static const double letterSpacingUi = 0.0;

  // ==========================================
  // Reading Surface Typography Constraints
  // User-controlled, independent of chrome
  // ==========================================
  static const double readingFontSizeMin = 14.0;
  static const double readingFontSizeMax = 32.0;
  static const double readingFontSizeDefault = 18.0;

  /// Line height must never drop below 1.5 even at user's minimum spacing setting
  static const double readingLineHeightMin = 1.5;
  static const double readingLineHeightMax = 2.2;
  static const double readingLineHeightDefault = 1.6;

  static const double readingLetterSpacingMin = 0.0;
  static const double readingLetterSpacingMax = 0.12;
  static const double readingLetterSpacingDefault = 0.04;

  // ==========================================
  // Spacing Scale (8px-based)
  // ==========================================
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 24.0;
  static const double space6 = 32.0;
  static const double space7 = 48.0;
  static const double space8 = 64.0;

  // ==========================================
  // Radius Tokens (Soft, Rounded, Non-Clinical)
  // ==========================================
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 22.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(radiusPill));

  // ==========================================
  // Shadows (Soft, Shallow, Low-Noise)
  // ==========================================
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color.fromRGBO(33, 29, 26, 0.06),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color.fromRGBO(33, 29, 26, 0.08),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color.fromRGBO(33, 29, 26, 0.10),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ==========================================
  // Motion Tokens (Deliberately Short, No Parallax)
  // ==========================================
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 160);
  static const Duration durationNormal = Duration(milliseconds: 240);

  // ==========================================
  // Touch & Pointer Target
  // Minimum 44x44px for every interactive element
  // ==========================================
  static const double minTouchTarget = 44.0;
}
