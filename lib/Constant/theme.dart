import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vmpa/Constant/color.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          backgroundColor: AppColors.primary,
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          backgroundColor: AppColors.transparent,
          side: const BorderSide(color: AppColors.grey, width: 1),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
        displayMedium: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
        displaySmall: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
        titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
        titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: AppColors.white,
            ),
        titleSmall: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: AppColors.white,
            ),
        headlineLarge: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
        headlineMedium: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
        headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: AppColors.white,
            ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
        bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.grey,
              fontFamily: GoogleFonts.barlow().fontFamily,
            ),
        labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.barlow().fontFamily,
              color: AppColors.black,
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
      ),
    );
  }
}
