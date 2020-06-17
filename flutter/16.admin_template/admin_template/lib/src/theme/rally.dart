import 'package:admin_template/src/color/rally.dart';
import 'package:admin_template/src/layout/letter_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData rallyTheme = _buildRallyTheme();

ThemeData _buildRallyTheme() {
  final base = ThemeData.dark();
  return ThemeData(
    appBarTheme: const AppBarTheme(brightness: Brightness.dark, elevation: 0),
    scaffoldBackgroundColor: RallyColors.primaryBackground,
    primaryColor: RallyColors.primaryBackground,
    focusColor: RallyColors.focusColor,
    textTheme: _buildRallyTextTheme(base.textTheme),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: RallyColors.gray,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: RallyColors.inputBackground,
      focusedBorder: InputBorder.none,
    ),
    iconTheme: IconThemeData(color: Colors.grey),
  );
}

TextTheme _buildRallyTextTheme(TextTheme base) {
  return base
      .copyWith(
        bodyText2: GoogleFonts.robotoCondensed(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacingOrNone(0.5),
        ),
        bodyText1: GoogleFonts.eczar(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          letterSpacing: letterSpacingOrNone(1.4),
        ),
        button: GoogleFonts.robotoCondensed(
          fontWeight: FontWeight.w700,
          letterSpacing: letterSpacingOrNone(2.8),
        ),
        headline5: GoogleFonts.eczar(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          letterSpacing: letterSpacingOrNone(1.4),
        ),
      )
      .apply(
        displayColor: Colors.white,
        bodyColor: Colors.white,
      );
}
