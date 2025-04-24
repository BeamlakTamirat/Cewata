import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light theme colors
  static const primary = Color(0xFF4A148C); // Deep purple 900
  static const secondary = Color(0xFF7C4DFF); // Deep purple A200
  static const background = Color(0xFFF8F6FF); // Very light purple tint
  static const surface = Color(0xFFF1EAFF); // Lighter purple tint
  static const text = Color(0xFF2D2D2D);
  static const accent = Color(0xFF9C27B0); // Purple 500
  static const tertiary = Color(0xFF3949AB); // Indigo for tertiary actions

  // Gradient colors for light theme
  static const lightGradientStart =
      Color(0xFFE1D6F0); // Darkened Deep purple 50
  static const lightGradientEnd = Color(0xFFDCDEF1); // Darkened Indigo 50

  // Dark theme colors
  static const primaryDark = Color(0xFFB39DDB); // Deep purple 200
  static const secondaryDark = Color(0xFFB388FF); // Deep purple A100
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const textDark = Color(0xFFF2F2F2);
  static const accentDark = Color(0xFFCE93D8); // Purple 200
  static const tertiaryDark = Color(0xFF7986CB); // Indigo 300

  // Gradient colors for dark theme
  static const darkGradientStart = Color(0xFF1A1139); // Very dark purple
  static const darkGradientEnd = Color(0xFF121212); // Material dark background
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.text,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme:
        GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme).copyWith(
      headlineLarge: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      headlineMedium: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shadowColor: AppColors.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.4),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.primary,
      centerTitle: true,
      titleTextStyle: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB00020)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFD1C4E9), // Deep purple 100
      thickness: 1,
      space: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColors.primary;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      disabledColor: Colors.grey.shade300,
      selectedColor: AppColors.primary.withOpacity(0.2),
      secondarySelectedColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelStyle: const TextStyle(color: AppColors.text),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      tertiary: AppColors.tertiaryDark,
      surface: AppColors.surfaceDark,
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textDark,
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      headlineMedium: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shadowColor: AppColors.primaryDark.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: AppColors.primaryDark.withOpacity(0.4),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: const BorderSide(color: AppColors.primaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.primaryDark,
      centerTitle: true,
      titleTextStyle: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.primaryDark,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryDark,
      foregroundColor: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryDark.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCF6679)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF4A148C), // Deep purple 900 (but darker for dark theme)
      thickness: 1,
      space: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.primaryDark.withOpacity(0.3);
          }
          return AppColors.primaryDark;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      disabledColor: Colors.grey.shade800,
      selectedColor: AppColors.primaryDark.withOpacity(0.2),
      secondarySelectedColor: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelStyle: const TextStyle(color: AppColors.textDark),
      secondaryLabelStyle: const TextStyle(color: Colors.black),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primaryDark.withOpacity(0.2)),
      ),
    ),
  );

  // Helper method to create a gradient background decoration
  static BoxDecoration gradientBackground({bool isDark = false}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
            : [AppColors.lightGradientStart, AppColors.lightGradientEnd],
      ),
    );
  }
}
