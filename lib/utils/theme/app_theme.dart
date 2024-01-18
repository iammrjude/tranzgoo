import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
// import 'package:tranzgoo/utils/theme/app_style.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldLayoutColor,
      primaryColor: AppColors.primaryColor,
      textTheme: GoogleFonts.leagueSpartanTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.scaffoldLayoutColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.primaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0, color: AppColors.scaffoldLayoutColor));
}
