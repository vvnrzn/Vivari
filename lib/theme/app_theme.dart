import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class VivariColors {
  static const primary = Color(0xFF4F9D92);
  static const secondary = Color(0xFF213536);
  static const background = Color(0xFF0E1718);
  static const surface = Color(0xFF172526);
  static const positive = Color(0xFF8BAF8A);
  static const warning = Color(0xFFC59B52);
  static const error = Color(0xFFB85C50);
  static const textPrimary = Color(0xFFE6EEEE);
  static const textMuted = Color(0xFFA7B9BA);
  static const border = Color(0xFF304344);
}

abstract final class AppSpacing {
  static const screen = 24.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
}

abstract final class VivariTheme {
  static ThemeData get app {
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: VivariColors.primary,
      onPrimary: VivariColors.background,
      secondary: VivariColors.secondary,
      onSecondary: VivariColors.textPrimary,
      surface: VivariColors.surface,
      onSurface: VivariColors.textPrimary,
      error: VivariColors.error,
      onError: VivariColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: VivariColors.background,
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.spaceGrotesk(
          color: VivariColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.dmSans(
          color: VivariColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: GoogleFonts.dmMono(
          color: VivariColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: GoogleFonts.dmSans(
          color: VivariColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.dmSans(
          color: VivariColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: GoogleFonts.dmMono(
          color: VivariColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: GoogleFonts.dmSans(
          color: VivariColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardThemeData(
        color: VivariColors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: VivariColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VivariColors.primary,
          foregroundColor: VivariColors.background,
          minimumSize: const Size(0, 56),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: VivariColors.primary),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: VivariColors.primary,
          textStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: VivariColors.textPrimary,
          minimumSize: const Size(36, 36),
          maximumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: VivariColors.border),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: VivariColors.textMuted, size: 20),
      dividerColor: VivariColors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: VivariColors.background,
        foregroundColor: VivariColors.textPrimary,
        centerTitle: false,
        titleSpacing: AppSpacing.screen,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: VivariColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: VivariColors.surface,
        indicatorColor: VivariColors.primary,
        height: 68,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected
                ? VivariColors.background
                : VivariColors.textMuted,
            size: 20,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((_) {
          return GoogleFonts.dmSans(
            color: VivariColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
    );
  }
}
