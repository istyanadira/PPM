import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna identitas Plantify.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF365B43);
  static const Color sage = Color(0xFF78977B);
  static const Color lightGreen = Color(0xFFE9F0E6);
  static const Color cream = Color(0xFFF8F6EF);
  static const Color darkText = Color(0xFF453D32);

  // Warna lembut untuk badge kategori.
  static const Color water = Color(0xFFDCEBF2);
  static const Color waterText = Color(0xFF2F6378);
  static const Color fertilizer = Color(0xFFF3E6C8);
  static const Color fertilizerText = Color(0xFF7A5A12);
  static const Color maintenance = Color(0xFFE5E0F0);
  static const Color maintenanceText = Color(0xFF5A4A82);
}

/// Jarak standar agar spacing konsisten di seluruh aplikasi.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Sudut membulat standar.
class AppRadius {
  AppRadius._();

  static const double card = 20;
  static const double chip = 12;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.sage,
      surface: AppColors.cream,
      onSurface: AppColors.darkText,
      primaryContainer: AppColors.lightGreen,
      onPrimaryContainer: AppColors.primary,
    );

    // Judul memakai Poppins SemiBold.
    TextStyle heading(double size) => GoogleFonts.poppins(
          fontSize: size,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        );

    // Isi memakai Inter Regular, caption memakai Inter Medium.
    TextStyle body(double size, {FontWeight? weight}) => GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight ?? FontWeight.w400,
          color: AppColors.darkText,
        );

    // TextTheme disusun langsung dari TextStyle.
    final textTheme = TextTheme(
      headlineMedium: heading(26),
      headlineSmall: heading(22),
      titleLarge: heading(20),
      titleMedium: heading(16),
      titleSmall: heading(14),
      bodyLarge: body(16),
      bodyMedium: body(14),
      bodySmall: body(12),
      labelLarge: body(14, weight: FontWeight.w500),
      labelMedium: body(12, weight: FontWeight.w500),
      labelSmall: body(11, weight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: heading(20),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.lightGreen),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lightGreen,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.sage,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.sage,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}