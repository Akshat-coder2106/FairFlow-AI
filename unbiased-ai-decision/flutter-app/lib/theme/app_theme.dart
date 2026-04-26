import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color deepNavy = Color(0xFF1A2340);
  static const Color deepNavyDark = Color(0xFF11182D);
  static const Color accentAmber = Color(0xFFFFC107);
  static const Color softWhite = Color(0xFFF8F9FC);
  static const Color softWhiteDark = Color(0xFF0F162A);
  static const Color cardDark = Color(0xFF18213A);
  static const Color textPrimary = Color(0xFF162033);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color unBlue = Color(0xFF009EDB);
}

class AppGradients {
  AppGradients._();

  static const LinearGradient hero = LinearGradient(
    colors: [
      AppColors.deepNavy,
      Color(0xFF26345E),
      Color(0xFF364777),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent = LinearGradient(
    colors: [
      Color(0xFFFFD54F),
      AppColors.accentAmber,
      Color(0xFFFFB300),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glass = LinearGradient(
    colors: [
      Color(0xFFFDFEFF),
      Color(0xFFF3F6FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlass = LinearGradient(
    colors: [
      Color(0xFF1E2745),
      Color(0xFF141C34),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.deepNavy,
      onPrimary: Colors.white,
      secondary: AppColors.accentAmber,
      onSecondary: AppColors.deepNavy,
      error: AppColors.danger,
      onError: Colors.white,
      surface: isDark ? AppColors.cardDark : Colors.white,
      onSurface: isDark ? Colors.white : AppColors.textPrimary,
      surfaceContainerHighest: isDark ? const Color(0xFF222D4C) : const Color(0xFFF1F5F9),
      onSurfaceVariant: isDark ? const Color(0xFFB8C0D9) : AppColors.textSecondary,
      outline: isDark ? const Color(0xFF33415E) : const Color(0xFFD9E1EC),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: isDark ? AppColors.softWhite : AppColors.deepNavy,
      onInverseSurface: isDark ? AppColors.deepNavy : Colors.white,
      inversePrimary: AppColors.accentAmber,
    );

    final TextTheme baseText = Typography.material2021().black.apply(
          bodyColor: isDark ? Colors.white : AppColors.textPrimary,
          displayColor: isDark ? Colors.white : AppColors.textPrimary,
        );

    final TextTheme textTheme = baseText.copyWith(
      headlineLarge: baseText.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: 14,
        height: 1.5,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.5,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: 12,
        color: isDark ? const Color(0xFFB8C0D9) : AppColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.softWhiteDark : AppColors.softWhite,
      textTheme: textTheme,
      fontFamily: 'Roboto',
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : AppColors.deepNavy,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? Colors.white : AppColors.deepNavy,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(isDark ? 0.28 : 0.08),
        color: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.12),
          backgroundColor: AppColors.deepNavy,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: AppColors.deepNavy,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          foregroundColor: isDark ? Colors.white : AppColors.deepNavy,
          side: BorderSide(
            color: isDark ? const Color(0xFF3B4B72) : const Color(0xFFD4DCEA),
            width: 1.4,
          ),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 4,
        backgroundColor: AppColors.accentAmber,
        foregroundColor: AppColors.deepNavy,
        extendedTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF202A47) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        helperStyle: textTheme.bodySmall,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? const Color(0xFFC4CBE0) : AppColors.textSecondary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? const Color(0xFF9FA9C4) : const Color(0xFF94A3B8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: AppColors.accentAmber, width: 1.8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF26314F) : const Color(0xFFF1F5F9),
        labelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.deepNavy,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1D2640) : AppColors.deepNavy,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF33415E) : const Color(0xFFE2E8F0),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentAmber,
        linearTrackColor: Color(0x22FFC107),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? Colors.white : AppColors.deepNavy,
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          color: isDark ? AppColors.deepNavy : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
