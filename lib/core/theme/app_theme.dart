import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_tokens.dart';

class AppTheme {
  AppTheme._();

  /// Calm, high-legibility, warm low-glare theme for Lexi Lens.
  /// Uses Atkinson Hyperlegible for all UI chrome typography.
  static ThemeData get warmTheme {
    final baseTextTheme = GoogleFonts.atkinsonHyperlegibleTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppTokens.colorBgCanvas,
      canvasColor: AppTokens.colorBgSurface,
      cardColor: AppTokens.colorBgSurface,
      dividerColor: AppTokens.colorBorderDefault,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppTokens.colorAccentPrimary,
        onPrimary: AppTokens.colorTextInverse,
        secondary: AppTokens.colorAccentWarm,
        onSecondary: AppTokens.colorTextPrimary,
        error: AppTokens.colorStateError,
        onError: AppTokens.colorTextInverse,
        surface: AppTokens.colorBgSurface,
        onSurface: AppTokens.colorTextPrimary,
        surfaceContainerHighest: AppTokens.colorBgSurfaceMuted,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: AppTokens.fontSize4xl,
          fontWeight: FontWeight.w700,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        displayMedium: const TextStyle(
          fontSize: AppTokens.fontSize3xl,
          fontWeight: FontWeight.w700,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        displaySmall: const TextStyle(
          fontSize: AppTokens.fontSize2xl,
          fontWeight: FontWeight.w700,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        headlineLarge: const TextStyle(
          fontSize: AppTokens.fontSizeXl,
          fontWeight: FontWeight.w700,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        headlineMedium: const TextStyle(
          fontSize: AppTokens.fontSizeLg,
          fontWeight: FontWeight.w600,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        titleLarge: const TextStyle(
          fontSize: AppTokens.fontSizeMd,
          fontWeight: FontWeight.w600,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        titleMedium: const TextStyle(
          fontSize: AppTokens.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: AppTokens.colorTextPrimary,
          height: AppTokens.lineHeightUi,
        ),
        bodyLarge: const TextStyle(
          fontSize: AppTokens.fontSizeMd,
          fontWeight: FontWeight.w400,
          color: AppTokens.colorTextSecondary,
          height: AppTokens.lineHeightUi,
        ),
        bodyMedium: const TextStyle(
          fontSize: AppTokens.fontSizeSm,
          fontWeight: FontWeight.w400,
          color: AppTokens.colorTextSecondary,
          height: AppTokens.lineHeightUi,
        ),
        bodySmall: const TextStyle(
          fontSize: AppTokens.fontSizeXs,
          fontWeight: FontWeight.w400,
          color: AppTokens.colorTextSecondary,
          height: AppTokens.lineHeightUi,
        ),
        labelLarge: const TextStyle(
          fontSize: AppTokens.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: AppTokens.colorTextPrimary,
          letterSpacing: 0.1,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTokens.colorBgSurfaceMuted,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppTokens.colorTextPrimary),
        titleTextStyle: TextStyle(
          fontSize: AppTokens.fontSizeLg,
          fontWeight: FontWeight.w700,
          color: AppTokens.colorTextPrimary,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTokens.colorAccentPrimary,
        inactiveTrackColor: AppTokens.colorBorderDefault,
        thumbColor: AppTokens.colorAccentPrimary,
        overlayColor: AppTokens.colorAccentPrimary.withValues(alpha: 0.15),
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.colorBgSurfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.space3,
          vertical: AppTokens.space3,
        ),
        labelStyle: const TextStyle(
          color: AppTokens.colorTextSecondary,
          fontSize: AppTokens.fontSizeSm,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppTokens.colorTextSecondary.withValues(alpha: 0.7),
          fontSize: AppTokens.fontSizeSm,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppTokens.borderRadiusSm,
          borderSide: BorderSide(color: AppTokens.colorBorderDefault, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppTokens.borderRadiusSm,
          borderSide: BorderSide(color: AppTokens.colorStateFocus, width: 2.0),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.colorAccentPrimary,
          foregroundColor: AppTokens.colorTextInverse,
          elevation: 0,
          minimumSize: const Size(AppTokens.minTouchTarget, AppTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space3,
            vertical: AppTokens.space2,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.borderRadiusSm,
          ),
          textStyle: const TextStyle(
            fontSize: AppTokens.fontSizeSm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.colorTextPrimary,
          minimumSize: const Size(AppTokens.minTouchTarget, AppTokens.minTouchTarget),
          side: const BorderSide(color: AppTokens.colorBorderStrong, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space3,
            vertical: AppTokens.space2,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.borderRadiusSm,
          ),
          textStyle: const TextStyle(
            fontSize: AppTokens.fontSizeSm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.colorAccentPrimary,
          minimumSize: const Size(AppTokens.minTouchTarget, AppTokens.minTouchTarget),
          textStyle: const TextStyle(
            fontSize: AppTokens.fontSizeSm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Alias for backward compatibility if any legacy code refers to darkTheme
  static ThemeData get darkTheme => warmTheme;
}
