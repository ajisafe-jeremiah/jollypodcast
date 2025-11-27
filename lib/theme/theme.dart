import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primaryGreen = Color(0xff00C853);
  static const primaryGreenDark = Color(0xff00943A);
  static const limeAccent = Color(0xffC8FF48); 
  static const forestGreen = Color(0xFF0A1E1E);

  // Backgrounds
  static const darkBackground = Color(0xff0A0A0A);
  static const cardDark = Color(0xff1A1A1A);

  // Neutral
  static const white = Color(0xffffffff);
  static const greyText = Color(0xffB5B5B5);
  static const greyLight = Color(0xffE6E6E6);

  // Buttons
  static const blueButton = Color(0xff0A84FF);
  static const primaryTeal = Color(0xff003B3A); // button background


  // Error
  static const red = Color(0xffff3b30);
}

class AppTheme {
  static final TextTheme _textTheme = TextTheme(
    displaySmall: GoogleFonts.raleway(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    ),
    headlineMedium: GoogleFonts.raleway(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    headlineSmall: GoogleFonts.raleway(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
    titleLarge: GoogleFonts.raleway(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.white,
    ),
    bodyLarge: GoogleFonts.raleway(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.3,
      color: AppColors.greyText,
    ),
    bodyMedium: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      color: AppColors.greyText,
    ),
    labelLarge: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: AppColors.white,
    ),
    titleMedium: GoogleFonts.raleway(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.white,
    ),
    titleSmall: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.white,
    ),
    bodySmall: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.greyText,
    ),
  );

  static final _btnTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.white,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  // static final _btnTheme = ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: AppColors.primaryTeal,
  //     foregroundColor: AppColors.white,
  //     minimumSize: const Size.fromHeight(52),
  //     shape: const StadiumBorder(),
  //     textStyle: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w600),
  //   ),
  // );


  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkBackground,

    textTheme: _textTheme,

    elevatedButtonTheme: _btnTheme,

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _textTheme.bodyLarge?.copyWith(color: AppColors.white),
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryGreen,
      selectionColor: AppColors.primaryGreenDark,
      selectionHandleColor: AppColors.primaryGreen,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreen;
        }
        return AppColors.darkBackground;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      hintStyle: GoogleFonts.raleway(color: AppColors.greyText, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.cardDark),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );
}
