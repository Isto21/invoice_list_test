import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_list_test/config/constants/consts.dart';

ColorScheme colorScheme(int isDarkMode) => ColorScheme.fromSeed(
  seedColor: ApkConstants.primaryApkColor,
  brightness: (isDarkMode == ApkConstants.darkMode)
      ? Brightness.dark
      : (isDarkMode == ApkConstants.lightMode)
      ? Brightness.light
      : WidgetsBinding.instance.platformDispatcher.platformBrightness,
);

class AppTheme {
  final int selectedColor;
  final int isDark;

  AppTheme({this.selectedColor = 0, this.isDark = ApkConstants.darkMode});

  ThemeData theme() {
    return _theme(isDark);
  }

  ThemeData themeLight() {
    return _theme(ApkConstants.lightMode);
  }

  ThemeData themeDark() {
    return _theme(ApkConstants.darkMode);
  }

  ThemeData _theme(int isDarkMode) {
    return ThemeData(
      cardTheme: CardThemeData(
        surfaceTintColor: colorScheme(isDarkMode).surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),

      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(const TextTheme()),
      colorScheme: colorScheme(isDarkMode),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme(isDarkMode).surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme(isDarkMode).primary),
        titleTextStyle: TextStyle(
          color: colorScheme(isDarkMode).onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(
          color: ApkConstants.primaryApkColor,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme(isDarkMode).surfaceContainerHighest,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ApkConstants.primaryApkColor,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ApkConstants.primaryApkColor,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIconColor: const Color(0xff9C9EA4),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        // border: OutlineInputBorder(
        //   borderSide: const BorderSide(
        //     color: ApkConstants.primaryApkColor,
        //     width: 1,
        //     style: BorderStyle.solid,
        //   ),
        //   borderRadius: BorderRadius.circular(12),
        // ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: ApkConstants.primaryApkColor),
            ),
          ),
          alignment: Alignment.center,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(4),
          backgroundColor: const WidgetStatePropertyAll(
            ApkConstants.primaryApkColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
          // textStyle: const WidgetStatePropertyAll(bodyLarge),
          alignment: Alignment.center,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  AppTheme copyWith({int? selectedColor, int? isDark}) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDark: isDark ?? this.isDark,
    );
  }
}
